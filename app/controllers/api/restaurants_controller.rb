module Api
	class RestaurantsController < BaseController

		def index
			param! :latitude, 	Float, required: true
			param! :longitude, 	Float, required: true

			render json: Restaurant.near([params[:latitude], params[:longitude]], 5, :units => :km), each_serializer: RestaurantArraySerializer
		end

		def show
			restaurant = Restaurant.where(id: params[:id]).first
			if restaurant.present?
				render json: restaurant
			else
				error404("Restaurant with id #{params[:id]} does not exists")
			end
		end

		def check_valid_address
			param! :latitude, 	Float, required: true
			param! :longitude, 	Float, required: true

			restaurant = Restaurant.where(id: params[:restaurant_id]).first
			error404("Restaurant with id #{params[:id]} does not exists") and return unless restaurant.present?
			render json: { valid: restaurant.can_delivery_to_address?(params[:latitude], params[:longitude])  }
		end

	end
end