module Api
	class OrdersController < BaseController

		before_action :authenticate_user!, only: [:index]

		def index
			render json: current_user.orders
		end

	end
end