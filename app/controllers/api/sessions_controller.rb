module Api
	class SessionsController < BaseController

		before_action :authenticate_user!, only: [:destroy]

		def create
			param! :email, 		String, required: true, format: User::VALID_EMAIL_REGEX
      param! :password, String, required: true, min_length: 6
      
      user = User.where(email: params[:email]).first
      if user.present? and user.valid_password?(params[:password])
      	render json: { user_id: user.id, access_token: user.generate_access_token }
      else
      	error401
      end
		end

		def destroy
			if success = current_user.remove_access_token
				render json: { success: success, message: 'Successfully Logged out'}
			else
				render json: { success: success, message: current_user.errors.full_messages }
			end
		end
		
	end
end