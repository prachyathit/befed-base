class OrdersController < ApplicationController
  before_action :logged_in_user, only: [:index]
  before_action :admin_user, only: [:index]
  before_action :get_cart_size
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def show
  end
  def index
    @orders = Order.order(created_at: :desc).paginate(page: params[:page], :per_page => 10)
    @ordersall = Order.all
    @cashtoday = Order.today.where(payment_type: 0)
    @cashyesterday = Order.yesterday.where(payment_type: 0)
    # @orderscr = Order.today.where(payment_type: 1)
    @cashbyagenttoday = @cashtoday.group(:agent).sum(:total)
    @cashbyagentyesterday = @cashyesterday.group(:agent).sum(:total)
    @totaltoday = Order.today.sum(:total)
    @totalyesterday = Order.yesterday.sum(:total)
    
    respond_to do |format|
      format.html
      format.csv { send_data @ordersall.to_csv }
    end
  end
  
  def edit
  end
  
  def update
  respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_url, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
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

    def set_order
      @order = Order.find(params[:id])
    end
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    def order_params
      params.require(:order).permit(:sub_total, :delivery_fee, :service_fee, :total, :agent)
    end
end
