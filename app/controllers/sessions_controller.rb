class SessionsController < ApplicationController
  before_action :get_cart_size

  def new
    unless session[:saddress]
      session[:saddress] = {}
    end
    unless logged_in?
      @user = User.new
    else
      redirect_to root_url
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      redirect_back_or root_path
    else
      flash.now[:danger] = "Invalid email/password combination"
      @user = User.new
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    session.delete(:cart)
    session.delete(:saddress)
    redirect_to root_url
  end
end
