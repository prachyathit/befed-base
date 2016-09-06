module Api
	class AddressesController < BaseController

		before_action :authenticate_user!

		def index
      render json: current_user.addresses
    end

    def show
      render json: current_address
    end

		private

    def current_address
      @current_address ||= current_user.addresses.where(id: params[:id]).first
    end
	end
end