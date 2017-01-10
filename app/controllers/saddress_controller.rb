class SaddressController < ApplicationController
  def new
    # @places = Place.all
    session[:saddress] ||= {}

    if logged_in?
      logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
      logger.tagged("Test") { logger.info "SESSION" }
      logger.tagged("Test") { logger.info session.inspect }
      if session[:saddress].empty?
        default_address = current_user.default_address
        if default_address.present?
          session[:saddress][:raw] = default_address.attributes.except(:created_at, :updated_at)
          session[:saddress][:faddress] = default_address.full_address_with_name
          redirect_to restaurants_url
        end
      else
        redirect_to restaurants_url
      end
    end
  end

  def create
    unless params[:saddress].empty?
      address = Address.new(JSON.parse(params[:saddress][:address]))
      session[:saddress][:raw] = JSON.parse(params[:saddress][:address])
      session[:saddress][:faddress] = address.full_address_with_name
      session[:saddress][:raw][:latitude] = params[:saddress][:latitude]
      session[:saddress][:raw][:longitude] = params[:saddress][:longitude]
      get_cart_size
      redirect_to params[:redirect_url]
    else
      flash[:danger] = "Location can't be blank"
      redirect_to root_url
    end
  end

  def update
    if params[:address_id]
      address = Address.where(id: params[:address_id]).first
      session[:saddress][:raw] = address.attributes
      session[:saddress][:faddress] = address.full_address_with_name
      session[:saddress][:latitude] = address.latitude
      session[:saddress][:longitude] = address.longitude
    end
    redirect_to restaurants_url
  end
end
