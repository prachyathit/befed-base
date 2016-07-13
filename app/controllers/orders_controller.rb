class OrdersController < ApplicationController
  before_action :logged_in_user, only: [:index]
  before_action :admin_user, only: [:index]
  before_action :get_cart_size

  def index
    @orders = Order.paginate(page: params[:page], :per_page => 10)
    @ordersall = Order.all
    
    respond_to do |format|
      format.html
      format.csv { send_data @ordersall.to_csv }
    end
  end

 
  private

    # Before filters

    # Confirm a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end


    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
