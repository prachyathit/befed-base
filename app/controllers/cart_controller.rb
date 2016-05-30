class CartController < ApplicationController
before_action :logged_in_user, only: [:checkout, :submit]
before_action :check_cart_status, only: [:checkout, :submit]
after_action :get_cart_size

  def add_new
    @food_id = params[:id]
    @food = Food.find(params[:id])
    @options = @food.options
    # # If the card has already been created, use an existing cart else creates a new cart
    unless session[:cart]
      session[:cart] = {}
    end
  end

  def add_create
    line_id = session[:cart].size + 1
    session[:cart][line_id] = {}
    session[:cart][line_id][:food_id] = params[:food_id]
    session[:cart][line_id][:quantity] = params[:cart][:quantity]
    session[:cart][line_id][:special] = params[:cart][:special]
    session[:cart][line_id][:options] = params[:value]
    get_cart_size

  end

  def clear_cart
    session[:cart] = nil
    redirect_to :action => :index
  end

  def line_delete
    session[:cart].delete(params[:id])
    redirect_to checkout_path
  end

  def index
    # If there is a cart pass it to the page to display, else pass an empty value
    if session[:cart]
      @cart = session[:cart]
    else
      @cart = {}
    end
    get_cart_size
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
    get_cart_size

  end

  def submit
    # Submit order
    @user = current_user
    rr11 = Restaurant.find(session[:restaurant_id])
    dbur = Geocoder::Calculations.distance_between([current_user.latitude,current_user.longitude], [rr11.latitude,rr11.longitude]) #Distance between current user and restuarant
    if dbur <= 5
      begin
        ActiveRecord::Base.transaction do
          @cart = session[:cart]
          @order = Order.process!(user: @user, cart: @cart)
          payment = create_new_payment!(@order)
          UserMailer.delivery_confirmation(@user, @cart, @order).deliver_now
          UserMailer.order_placed(@user, @cart, @order).deliver_now
          flash.now[:info] = "Email confirmation will be sent to you shortly"
          session[:cart] = nil
        end
      rescue => e
        flash[:danger] = 'Something went wrong. Please try again later.'
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
