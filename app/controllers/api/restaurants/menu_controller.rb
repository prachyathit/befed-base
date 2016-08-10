module Api
	module Restaurants
		class MenuController < BaseController

			before_action :validate_restaurant!

			def index
				render json: current_restaurant.foods.group_by(&:cat)
			end

			def show
				menu = current_restaurant.foods.where(id: params[:id]).first
				if menu.present?
					render json: menu
				else
					error404("Menu with id #{params[:id]} in restaurant #{current_restaurant.name} does not exists")
				end
			end

			private

			def validate_restaurant!
				param! :restaurant_id, 	Integer, required: true
				error404("Restaurant with id #{params[:restaurant_id]} does not exists") unless current_restaurant.present?
			end

			def current_restaurant
				@current_restaurant ||= Restaurant.where(id: params[:restaurant_id]).first
			end

		end
	end
end