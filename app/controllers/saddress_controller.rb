class SaddressController < ApplicationController
  def new
    unless session[:saddress]
      session[:saddress] = {}
    end
    if logged_in?
      address = current_user.address
      result = Geocoder.search(address)
      unless result.empty?
        latitude = result[0].data["geometry"]["location"]["lat"]
        longitude = result[0].data["geometry"]["location"]["lng"]
        session[:saddress][:faddress] = address
        session[:saddress][:latitude] = latitude
        session[:saddress][:longitude] = longitude
      end
      redirect_to restaurants_url
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
