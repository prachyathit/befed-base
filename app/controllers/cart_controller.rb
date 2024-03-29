class CartController < ApplicationController
  before_action :logged_in_user, only: [:checkout, :submit]
  before_action :check_cart_status, only: [:checkout, :submit]

  def add_new
    @food_id = params[:id]
    @food = Food.find(params[:id])
    @options = @food.options
  end

  def add_create
    line_id = session[:cart].keys.last.to_i + 1
    session[:cart][line_id] = {}
    session[:cart][line_id][:food_id] = params[:food_id]
    session[:cart][line_id][:quantity] = params[:cart][:quantity]
    session[:cart][line_id][:special] = params[:cart][:special]
    session[:cart][line_id][:options] = params[:value]
    get_cart_size

  end

  def clear_cart
    session[:cart] = {}
    redirect_to :action => :index
  end

  def line_delete
    # in local cart key is String but on prod cart key is int
    session[:cart].delete(params[:id])
    session[:cart].delete(params[:id].to_i)
    redirect_to cart_path
  end

  def index
    # If there is a cart pass it to the page to display, else pass an empty value
    
    unless session[:restaurant_id].nil?
      @min_order = Restaurant.find(session[:restaurant_id]).min_order
    else
      @min_order = 0
    end
    if session[:cart]
      @cart = session[:cart]
      @cart.deep_symbolize_keys!
    else
      @cart = {}
    end
    get_cart_size
  end

  def checkout
    # If there is a cart pass it to the page to display, else pass an empty value
    @restaurant = Restaurant.find(session[:restaurant_id])
    min_order = @restaurant.min_order
    if session[:total] < min_order
      flash[:danger] = "Minimum order is #{min_order} ฿, please order some more."
      redirect_to cart_url
    end
    @delivery_fee = current_user.delivery_fee
    
    if session[:cart]
      @cart = session[:cart]
      @cart.deep_symbolize_keys!
      @user = current_user
      unless session[:saddress].empty?
        unless session[:saddress].is_a?(Hash) and session[:saddress][:raw].present? and session[:saddress][:raw][:id].present?
          @address = Address.default_from_params(
            @user, "Address#{@user.addresses.count + 1}",
            session[:saddress])
          session[:saddress] = {}
        end
      end
      if params[:address_id]
        @address = current_user.addresses.where(id: params[:address_id]).first
      end
      @address ||= current_user.default_address
      @address_valid = @restaurant.can_delivery_to_address?(@address.latitude, @address.longitude)
      @addresses = current_user.addresses
    else
      flash[:danger] = "Your cart is empty"
      render 'index'
    end
    session[:forwarding_url] = checkout_url
    get_cart_size

  end

  def submit
    min_order = Restaurant.find(session[:restaurant_id]).min_order
    if session[:total] < min_order
      flash[:danger] = "Minimum order is #{min_order} ฿, please order some more."
      redirect_to cart_url
    end
    # Submit order
    @user = current_user
    restaurant = Restaurant.find(session[:restaurant_id])
    if params[:address_id]
      address = @user.addresses.where(id: params[:address_id]).first
    end
    address ||= current_user.default_address
    if restaurant.can_delivery_to_address?(address.latitude,address.longitude)
    # if true
      begin
        ActiveRecord::Base.transaction do
          @rest_id = session[:restaurant_id]
          @cart = session[:cart]
          @order = Order.process!(user: @user, cart: @cart, 
            payment_type: params[:payment_type], 
            address_id: params[:address_id],
            rest_id: @rest_id)
          payment = create_new_payment!(@order)
          @order.create_order_food(@cart)
          
          TookanApiService.create_pickup_and_delivary_task(@user, @cart, @order).inspect

          UserMailer.order_placed(@user, @cart, @order).deliver_now
          UserMailer.delivery_request(@user, @cart, @order).deliver_now
          UserMailer.delivery_confirmation(@user, @cart, @order).deliver_now
          
          flash.now[:info] = "Email confirmation will be sent to you shortly"
          session[:cart] = nil
        end
      rescue OmiseGateway::InvalidCreditCardInfo => e 
        flash[:danger] = "Credit Card info is incorrect."
        logger.error("Message for the log file #{e.message}")
        redirect_to checkout_url
      rescue => e
        flash[:danger] = 'Something went wrong. Please try again later.'
        logger.error("Message for the log file #{e.message}")
        redirect_to checkout_url
      end
    else
      flash[:danger] = "Delivery address is not within the service area : ที่อยู่ของคุณอยู่นอกพื้นที่จัดส่ง"
      redirect_to checkout_url
    end
    get_cart_size
  end

  private

  def credit_card?
    params[:payment_type] == Payment::CREDIT_CARD
  end

  def create_new_payment!(order)
    credit_card? ? new_credit_card_payment!(order) : new_cash_payment!(order)
  end

  def new_credit_card_payment!(order)
    Payment::CreditCard.create!(order: order, token: params[:token], user: @user)
  end

  def new_cash_payment!(order)
    Payment::Cash.create!(order: order, user: @user)
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in / create account"
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
