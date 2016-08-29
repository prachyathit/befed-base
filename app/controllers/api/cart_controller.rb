module Api
	class CartController < BaseController

		before_action :authenticate_user!, only: [:checkout]

		def checkout
			param! :restaurant_id, 	Integer, required: true
			param! :items, 					Array, required: true do |item|
				item.param!	:menu_id,					Integer, required: true
				item.param! :quantity, 				Integer, required: true
				item.param! :special_request, String
				item.param! :options, 				Array do |opt|
					opt.param! :id,							Integer
					opt.param! :value_ids,			Array
				end
			end
			# prepare for multiple address
			# TODO: use this address to create shipping address instead of user address
			param! :address,				Hash, required: true do |a|
				a.param! :latitude,		Float, required: true
				a.param! :longitude,	Float, required: true
				a.param! :address,		String, required: true
				a.param! :instruction,String
			end

			unless restaurant = Restaurant.where(id: params[:restaurant_id]).first
				error400("Restaurant with id #{params[:restaurant_id]} does not exists.") and return
			end

			if restaurant.can_delivery_to_address?(current_user.latitude,current_user.longitude)
				cart = {}
				params[:items].each_with_index do |item, index|
					item_options = {}
					item[:options].each do |opt|
						option = Option.where(id: opt[:id]).first
						item_options[option.name.to_sym] = {
							option_value_ids: opt[:value_ids]
						}
					end
					cart[index] = {
						food_id: item[:menu_id],
						quantity: item[:quantity],
						special: item[:special_request],
						options: item_options
					}
				end
				
				begin
					ActiveRecord::Base.transaction do
						first_order = current_user.orders.count == 0
						order = Order.process!(user: current_user, cart: cart, 
							payment_type: Payment::CASH, first_order: first_order, 
							rest_id: restaurant.id)
						Payment::Cash.create!(order: order, user: current_user)
						order.create_order_food(cart)

						TookanApiService.create_pickup_and_delivary_task(current_user, cart, order).inspect

	          UserMailer.order_placed(current_user, cart, order).deliver_now
	          UserMailer.delivery_request(current_user, cart, order).deliver_now
	          UserMailer.delivery_confirmation(current_user, cart, order).deliver_now

	          render json: order and return
					end
				rescue Exception => e
					Rails.logger.error(e)
					error500("Something went wrong, Please try again later.") and return
				end
			else
				error400("The address is not in delivery region.") and return
			end
		end
	end
end