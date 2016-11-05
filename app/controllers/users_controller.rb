class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy]
  before_action :get_cart_size

  def index
    @users = User.paginate(page: params[:page])
    @usersall = User.all
      respond_to do |format|
      format.html
      format.csv { send_data @usersall.to_csv }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Temporary fix for non multiple address
      # TODO : Remove this when multiple address website launch
      @user.addresses.create(latitude: @user.latitude, 
        longitude: @user.longitude, 
        instruction: @user.address || "" + " " + @user.dinstruction || "")

      log_in @user
      flash[:success] = "Let's eat!"
      
      redirect_back_or restaurants_url
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
      # Temporary fix for non multiple address
      # TODO : Remove this when multiple address website launch
      @user.addresses.first.update(latitude: @user.latitude, 
        longitude: @user.longitude, 
        instruction: @user.address || "" + " " + @user.dinstruction || "")

      session[:saddress][:faddress] = @user.address
      session[:saddress][:latitude] = @user.latitude
      session[:saddress][:longitude] = @user.longitude
      # flash[:success] = "Profile updated"
      render 'edit'
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
