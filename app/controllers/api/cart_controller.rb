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
			param! :address_id,			Integer, required: true

			unless restaurant = Restaurant.where(id: params[:restaurant_id]).first
				error400("Restaurant with id #{params[:restaurant_id]} does not exists.") and return
			end

			unless address = current_user.addresses.where(id: params[:address_id]).first
				error400("Address with id #{params[:address_id]} does not exists.") and return
			end

			unless in_delivery_time
				error400("Sorry, our delivery hours is at 11:00 AM to 9:00 PM") and return
			end
			if restaurant.can_delivery_to_address?(address.latitude,address.longitude)
				cart = {}
				params[:items].each_with_index do |item, index|
					item_options = {}
					if item[:options].present?
						item[:options].each do |opt|
							option = Option.where(id: opt[:id]).first
							item_options[option.name.to_sym] = {
								option_value_ids: opt[:value_ids]
							}
						end	
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
						order = Order.process!(user: current_user, cart: cart, 
							payment_type: Payment::CASH, 
							rest_id: restaurant.id, address_id: params[:address_id])
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

		private

		def in_delivery_time
			open_time = Time.parse "11:00 am"
			close_time = Time.parse "9:00 pm"
			current_time = Time.now
			(current_time > open_time and current_time < close_time)
		end
	end
end