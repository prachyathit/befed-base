module Api
	class MenuController < BaseController

		before_action :validate_restaurant!
		before_action :validate_menu!, only: [:options]

		def index
			menu_by_category = current_restaurant.foods.select('foods.*', 
				'COUNT(food_options.id) AS option_count').
				joins("LEFT JOIN food_options ON foods.id = food_options.food_id").
				group('foods.id').group_by(&:cat)
			response = []
			menu_by_category.each do |category, menus|
				menu_obj = menus.map do |menu|
					m = {}
					m['id'] = menu.id
					m['name'] = menu.name
					m['price'] = menu.price.to_s
					m['image_url'] = menu.image_url
					m['recommend'] = menu.rec
					m['thai_name'] = menu.name.split(" : ")[1]
					m['eng_name'] = menu.name.split(" : ")[0]
					m['has_option'] = (menu.option_count > 0)
					m
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
			options = current_menu.options.order(:id)
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