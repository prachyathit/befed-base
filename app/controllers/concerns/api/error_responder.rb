module Api
  module ErrorResponder
    extend ActiveSupport::Concern

    def error(status, message="")
      render json: { message: message, status: status }, status: status 
    end

    def error400(message="Invalid Params")
      error(400, message)
    end

    def error401(message="Unauthorized")
      error(401, message)
    end

    def error404(message="Not Found")
      error(404, message)
    end

    def error422(message="Unprocessable Entity")
      error(422, message)
    end

    def error500(message="Something went wrong, please try again later")
      error(500, message)
    end
    
  end
end