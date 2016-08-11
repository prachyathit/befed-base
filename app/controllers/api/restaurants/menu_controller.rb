module Api
	module Restaurants
		class MenuController < BaseController

			before_action :validate_restaurant!

			def index
				menu_by_category = current_restaurant.foods.select(:id, :name, :price, :rec, :cat).group_by(&:cat).to_json
				menu_by_category = JSON.parse(menu_by_category)
				menu_by_category.each do |category, menus|
					menus.each do |menu|
						menu['recommend'] = menu.delete('rec')
						menu.delete('cat')
					end
				end
				render json: menu_by_category
			end

			def show
				menu = current_restaurant.foods.where(id: params[:id]).first
				if menu.present?
					render json: menu, serializer: MenuSerializer
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