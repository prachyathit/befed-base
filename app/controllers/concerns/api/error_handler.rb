module ErrorHandler
  module ClassMethods
  end
  
  module InstanceMethods
    def response_error(error)
      render json: { param: error.param, message: error.message }, status: 400
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.class_eval do 
      rescue_from RailsParam::Param::InvalidParameterError, with: :response_error
    end
  end
end