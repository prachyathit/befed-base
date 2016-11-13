class SaddressController < ApplicationController
  def new
    @places = Place.all
    unless session[:saddress]
      session[:saddress] = {}
    end
    if logged_in?
      if session[:saddress]["faddress"].nil?
        session[:saddress][:faddress] = current_user.address
        session[:saddress][:latitude] = current_user.latitude
        session[:saddress][:longitude] = current_user.longitude
      end
      redirect_to restaurants_url
    
    end
  end
  def create
    unless params[:saddress].empty?
      address = Address.new(JSON.parse(params[:saddress][:address]))
      session[:saddress][:faddress] = address.full_address
      session[:saddress][:latitude] = params[:saddress][:latitude]
      session[:saddress][:longitude] = params[:saddress][:longitude]
      get_cart_size
      redirect_to restaurants_url
    else
      flash[:danger] = "Location can't be blank"
      redirect_to root_url
    end
  end
end
