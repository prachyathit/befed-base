class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :show, :destroy]
  before_action :get_cart_size

  def index
    @users = User.paginate(page: params[:page])
    @usersall = User.all
      respond_to do |format|
      format.html
      format.csv { send_data @usersall.to_csv }
    end
  end

  def show
    @user = User.where(id: params[:id]).first
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    unless session[:saddress].present? and session[:saddress]["raw"].present?
      flash[:danger] = "Please enter delivery location"
      render template: 'sessions/new' and return
    end
    
    if @user.save
      address = Address.new(JSON.parse(session[:saddress]["raw"]))
      address.name ||= 'Default'
      address.user_id = @user.id
      address.latitude = user_params[:latitude]
      address.longitude = user_params[:longitude]
      address.save
      session[:saddress] = {}

      log_in @user
      flash[:success] = "Let's eat!"
      
      redirect_back_or root_url
    else
      render template: 'sessions/new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def edit_address

  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      default_address = @user.default_address
      session[:saddress][:faddress] = default_address.full_address
      session[:saddress][:latitude] = default_address.latitude
      session[:saddress][:longitude] = default_address.longitude
      # flash[:success] = "Profile updated"
      redirect_to edit_user_path(current_user)
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit( :name, :email, :phone, :address, :dinstruction,
                                    :latitude, :longitude,
                                    :password, :password_confirmation)
    end

    # Before filters

    # Confirm a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end

    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
