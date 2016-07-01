class SessionsController < ApplicationController
  before_action :get_cart_size

  def new
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
