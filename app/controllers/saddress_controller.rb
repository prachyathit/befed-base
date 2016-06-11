class SaddressController < ApplicationController
  def new
    unless session[:saddress]
      session[:saddress] = {}
    end
    if logged_in?
      session[:saddress][:faddress] = current_user.address
      session[:saddress][:latitude] = current_user.latitude
      session[:saddress][:longitude] = current_user.longitude
    end
  end
  def create
    unless params[:saddress][:faddress].empty?
      session[:saddress][:faddress] = params[:saddress][:faddress]
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
