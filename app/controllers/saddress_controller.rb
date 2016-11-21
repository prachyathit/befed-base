class SaddressController < ApplicationController
  def new
    # @places = Place.all
    unless session[:saddress]
      session[:saddress] = {}
    end
    if logged_in?
      if session[:saddress].empty?
        default_address = current_user.default_address
        session[:saddress][:raw] = default_address.attributes
        session[:saddress][:faddress] = default_address.full_address
        session[:saddress][:latitude] = default_address.latitude
        session[:saddress][:longitude] = default_address.longitude
      end
      redirect_to restaurants_url
    end
  end
  def create
    unless params[:saddress].empty?
      address = Address.new(JSON.parse(params[:saddress][:address]))
      session[:saddress][:raw] = params[:saddress][:address]
      session[:saddress][:faddress] = address.full_address
      session[:saddress][:latitude] = params[:saddress][:latitude]
      session[:saddress][:longitude] = params[:saddress][:longitude]
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
      session[:saddress][:faddress] = address.full_address
      session[:saddress][:latitude] = address.latitude
      session[:saddress][:longitude] = address.longitude
    end
    redirect_to restaurants_url
  end
end
