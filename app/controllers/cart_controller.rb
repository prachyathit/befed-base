class CartController < ApplicationController
before_action :logged_in_user, only: [:checkout, :submit]
before_action :check_cart_status, only: [:checkout, :submit]

  def add_new
    @food_id = params[:id]
    # # If the card has already been created, use an existing cart else creates a new cart
    unless session[:cart]
      session[:cart] = {}
    end

    # @cart = session[:cart]
    # @cart[id] = [0, ""]
  end

  def add_create
    line_id = session[:cart].size + 1
    session[:cart][line_id] = {}
    session[:cart][line_id][:food_id] = params[:food_id]
    session[:cart][line_id][:quantity] = params[:cart][:quantity]
    session[:cart][line_id][:special] = params[:cart][:special]
  end

  def clear_cart
    session[:cart] = nil
    redirect_to :action => :index
  end

  def line_delete

    session[:cart].delete(params[:id])
    redirect_to cart_url
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
      flash.now[:info] = "Email confirmation will be sent to you shortly"
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

    # Cart is empty?
    def check_cart_status
      unless session[:cart]
        redirect_to root_url
      end
    end


end
