class StaticPagesController < ApplicationController
  before_action :get_cart_size
  def home
  end

  def help
  end

  def about
    begin
      t.t
    rescue => e
      logger.error("Message for the log file #{e.message}")
    end
  end

  def contact
  end
  
  def privacy
  end
  
  def terms
  end
end
