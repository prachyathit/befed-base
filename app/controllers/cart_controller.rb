class CartController < ApplicationController
before_action :logged_in_user, only: :checkout
  def add
    id = params[:id]
    # If the card has already been created, use an existing cart else creates a new cart
    if session[:cart]
      cart = session[:cart]
    else
      session[:cart] = {}
      cart = session[:cart]
    end
    # If the product has already been added to the cart, increment the value else set to 1
    if cart[id]
      cart[id] += 1
    else
      cart[id] = 1
    end
    redirect_to :action => :index
  end

  def clear_cart
    session[:cart] = nil
    redirect_to :action => :index
  end

  def index
    # If there is a cart pass it to the page to display, else pass an empty value
    if session[:cart]
      @cart = session[:cart]
    else
      @cart = {}
    end
  end

  def checkout
    # If there is a cart pass it to the page to display, else pass an empty value
    if session[:cart]
      @cart = session[:cart]
      @user = current_user
    else
      flash[:danger] = "Your cart is empty"
      render 'index'
    end
  end

  def submit
    # Submit order
      @cart = session[:cart]
      @user = current_user
      UserMailer.delivery_confirmation(@user,@cart).deliver_now
      flash.now[:info] = "Email confirmation has been sent to your email"
      session[:cart] = nil
      UserMailer.order_placed(@user,@cart).deliver_now
  end

  private

  # Before filter

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end


end
