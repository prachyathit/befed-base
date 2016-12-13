module Api
	class BaseController < ActionController::API
		include ActionController::Serialization
		include ErrorHandler
		include ErrorResponder

		def authenticate_user!
			error401 unless current_user.present?
		end

		def current_user
			access_token = request.headers['Authentication']
			user_id = current_user_id
			@current_user ||= User.where(id: user_id, access_token: access_token).first
		end

		def current_user_id
			request.headers['User-Id']
		end
	end
end