module Api
	class UsersController < BaseController

		before_action :authenticate_user!, only: [:show, :update]

		def create
			param! :email, 		String, required: true, format: User::VALID_EMAIL_REGEX
      param! :password, String, required: true, min_length: 6
      param! :name,			String, required: true
      param! :phone_no,	String, required: true
      param! :address,	String
      param! :latitude, Float
      param! :longitude,Float
      param! :delivery_instruction, String
      
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
      param! :phone_no,	String
      param! :address,	String
      param! :latitude, Float
      param! :longitude,Float
      param! :delivery_instruction, String

      if current_user.update(user_params)
      	render json: current_user
      else
      	error422(current_user.errors.full_messages)
      end
		end

		private

		def user_params
			params[:phone] = params[:phone_no]
			params[:dinstruction] = params[:delivery_instruction]
			params.permit( :name, :email, :phone, :address, :dinstruction, :latitude, :longitude, :password )
		end
	end
end