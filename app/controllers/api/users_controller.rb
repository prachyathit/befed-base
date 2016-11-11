module Api
	class UsersController < BaseController

		before_action :authenticate_user!, only: [:show, :update]

		def create
			param! :email, 		String, required: true, format: User::VALID_EMAIL_REGEX
      param! :password, String, required: true, min_length: 6
      param! :name,			String, required: true
      param! :phone_no,	String, required: true
      
      user = User.new(user_params)
      if user.save
      	render json: { user_id: user.id, access_token: user.generate_access_token }
      else
      	error422(user.errors.full_messages)
      end
		end

		def show
			render json: current_user
		end

		def update
			param! :email, 		String, format: User::VALID_EMAIL_REGEX
      param! :password, String, min_length: 6
      param! :name,			String
      # param! :phone_no,	String
      param! :default_address_id, Integer

      begin
        ActiveRecord::Base.transaction do
          current_user.update!(user_params)
          new_default_address = current_user.addresses.where(id: params["default_address_id"]).first
          raise Error unless new_default_address.present?
          current_user.set_default_address!(new_default_address)
        end
      rescue Exception => e
        Rails.logger.error(e)
        error422(current_user.errors.full_messages) and return
      end
      
      render json: current_user
		end

		private

		def user_params
			params[:phone] = params[:phone_no] if params[:phone_no].present?
			params[:dinstruction] = params[:delivery_instruction] if params[:delivery_instruction].present?
			params.permit( :name, :email, :phone, :address, :dinstruction, :latitude, :longitude, :password )
		end
	end
end