module Api
	class BaseController < ActionController::API
		include ActionController::Serialization
	  include ErrorHandler
	  include	ErrorResponder


		def authenticate_user!
			access_token = request.headers['Authentication']
			error401 unless current_user.present? and current_user.authenticated?(access_token)
		end

		def current_user
			@current_user ||= User.where(id: request.headers['User-ID']).first
		end
	end
end