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
				error404("Restaurant with #{params[:id]} does not exists")
			end
		end

	end
end