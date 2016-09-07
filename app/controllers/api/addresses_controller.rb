module Api
	class AddressesController < BaseController

		before_action :authenticate_user!

		def index
      render json: current_user.addresses
    end

    def show
      render json: current_address
    end

    def create
      param! :name,           String, required: true
      param! :is_default,     :boolean, default: false
      param! :latitude,       Float, required: true
      param! :longitude,      Float, required: true
      param! :instruction,    String
      param! :house_room_no,  String, required: true
      param! :street,         String, required: true
      param! :building_name,  String
      param! :floor,          String
      param! :province,       String
      param! :postal_code,    String

      address = current_user.addresses.new(address_params)
      if address.save
        render json: address
      else
        error422(address.errors.full_messages)
      end
    end

		private

    def current_address
      @current_address ||= current_user.addresses.where(id: params[:id]).first
    end

    def address_params
      params.permit( :name, :is_default, :latitude, :longitude, 
        :instruction, :house_room_no, :street, :building_name, 
        :floor, :province, :postal_code )
    end
	end
end