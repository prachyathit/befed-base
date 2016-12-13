module Api
	class OrdersController < BaseController

		before_action :authenticate_user!, only: [:index]

		def index
      if current_user_id == params[:user_id]
        render json: Order.all.unscoped.where(user_id: current_user_id).order(created_at: :desc)
      else
        error401
      end
		end

	end
end