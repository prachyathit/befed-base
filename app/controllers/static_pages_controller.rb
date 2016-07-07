class StaticPagesController < ApplicationController
  before_action :get_cart_size
  def home
  end

  def help
  end

  def about

  end

  def contact
  end
  
  def privacy
  end
  
  def terms
  end
end
