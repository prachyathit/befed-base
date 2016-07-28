module ErrorResponder
  extend ActiveSupport::Concern

  module ClassMethods
  end
  
  module InstanceMethods
    def error(status, message="")
      render json: { message: message }, status: status 
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
  end
  
end