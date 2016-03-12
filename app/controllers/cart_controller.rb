class CartController < ApplicationController
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
end
