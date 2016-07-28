module Api
	class SessionsController < BaseController

		def login
			param! :email, 		String, required: true, format: email_regexp
      param! :password, String, required: true, min_length: 6
      
      user = User.where(email: params[:email]).first
      if user.present? and user.valid_password?(params[:password])
      	response json: { user_id: user.id, access_token: user.access_token }
      else
      	error401
      end
		end

		def logout
		end

		def register
		end
	end
end