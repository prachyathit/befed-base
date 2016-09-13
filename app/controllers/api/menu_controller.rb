module Api
	class MenuController < BaseController

		before_action :validate_restaurant!
		before_action :validate_menu!, only: [:options]

		def index
			menu_by_category = current_restaurant.foods.select(:id, :name, :price, :rec, :cat).group_by(&:cat).to_json
			menu_by_category = JSON.parse(menu_by_category)
			response = []
			menu_by_category.each do |category, menus|
				menu_obj = menus.map do |menu|
					menu['recommend'] = menu.delete('rec')
					menu.delete('cat')
					menu
				end
				response_obj = {
					category_name: category,
					menus: menu_obj
				}
				response << response_obj
			end
			render json: response
		end

		def show
			menu = current_restaurant.foods.where(id: params[:id]).first
			if menu.present?
				render json: menu, serializer: MenuSerializer
			else
				error404("Menu with id #{params[:id]} in restaurant #{current_restaurant.name} does not exists")
			end
		end

		def options
			options = current_menu.options
			render json: options.includes(:option_values)
		end

		private

		def validate_restaurant!
			param! :restaurant_id, 	Integer, required: true
			error404("Restaurant with id #{params[:restaurant_id]} does not exists") unless current_restaurant.present?
		end

		def validate_menu!
			param! :menu_id, 	Integer, required: true
			error404("Menu with id #{params[:menu_id]} does not exists") unless current_menu.present?
		end

		def current_restaurant
			@current_restaurant ||= Restaurant.where(id: params[:restaurant_id]).first
		end

		def current_menu
			@current_menu ||= current_restaurant.foods.where(id: params[:menu_id]).first
		end

	end
end