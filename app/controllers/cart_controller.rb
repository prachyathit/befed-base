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
    session[:cart].delete(params[:id])
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
    else
      @cart = {}
    end
    get_cart_size
  end

  def checkout
    # If there is a cart pass it to the page to display, else pass an empty value
    min_order = Restaurant.find(session[:restaurant_id]).min_order
    if session[:total] < min_order
      flash[:danger] = "Minimum order is #{min_order} ฿, please order some more."
      redirect_to cart_url
    end
    if Order.find_by_user_id(current_user).nil?
      @first_order = true
    else
      @first_order = false
    end
    
    if session[:cart]
      @cart = session[:cart]
      @user = current_user
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
    if Order.find_by_user_id(current_user).nil?
      @first_order = true
    else
      @first_order = false
    end
    @user = current_user
    rr11 = Restaurant.find(session[:restaurant_id])
    dbur = Geocoder::Calculations.distance_between([current_user.latitude,current_user.longitude], [rr11.latitude,rr11.longitude]) #Distance between current user and restuarant
    if dbur <= 5
    # if true
      begin
        ActiveRecord::Base.transaction do
          @rest_id = session[:restaurant_id]
          @cart = session[:cart]
          @order = Order.process!(user: @user, cart: @cart, payment_type: credit_card?, first_order: @first_order, rest_id: @rest_id)
          payment = create_new_payment!(@order)
          create_order_food(@order, @cart)
          UserMailer.order_placed(@user, @cart, @order).deliver_now
          UserMailer.delivery_request(@user, @cart, @order).deliver_now
          UserMailer.delivery_confirmation(@user, @cart, @order).deliver_now
          
          flash.now[:info] = "Email confirmation will be sent to you shortly"
          session[:cart] = nil
        end
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
  
  def create_order_food(order, cart)
    cart.each do |k,v|
      food = Food.find_by(id: v['food_id'])
      food_price = food.price
      food_name = food.name
      food_cat = food.cat
      quantity = v["quantity"].to_i
      
      options = v["options"]
      unless options.nil?
        options.each do |option|
          option_value_id = option[1]["option_value_ids"]
          unless option_value_id.first.empty?
            if option_value_id.class == String
              option_value = OptionValue.find(option_value_id)
              food_price += option_value.price.to_i
            else
              option_value_id.each do |option_number|
                unless option_number.empty?
                  option_value = OptionValue.find(option_number)
                  food_price += option_value.price.to_i
                end
              end
            end
          end
        end
      end
      total = food_price * quantity
      OrderFood.create!(order_id: order.id, rest_id: order.rest_id, food_id: v["food_id"], food_name: food_name, food_cat: food_cat, quantity: quantity, total: total)
    end
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
