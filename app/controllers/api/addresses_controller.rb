module Api
	class AddressesController < BaseController

		before_action :authenticate_user!
    before_action :validates_presence_of_address!, only: [:show, :update, :destroy]

		def index
      render json: current_user.addresses
    end

    def show
      render json: current_address
    end

    def create
      param! :name,           String, required: true
      param! :latitude,       Float, required: true
      param! :longitude,      Float, required: true
      param! :house_room_no,  String, required: true
      param! :street,         String, required: true
      param! :is_default,     :boolean, default: false
      param! :instruction,    String
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

    def update
      param! :name,           String
      param! :latitude,       Float
      param! :longitude,      Float
      param! :house_room_no,  String
      param! :street,         String
      param! :is_default,     :boolean
      param! :instruction,    String
      param! :building_name,  String
      param! :floor,          String
      param! :province,       String
      param! :postal_code,    String

      current_address.assign_attributes(address_params)
      if current_address.save
        render json: current_address
      else
        error422(address.errors.full_messages)
      end
    end

    def destroy
      if success = current_address.destroy
        render json: { success: success, message: 'Successfully Destroy'}
      else
        render json: { success: success, message: current_address.errors.full_messages}
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

    def validates_presence_of_address!
      error404("Address with id #{params[:id]} does not exists") unless current_address.present?
    end
	end
end