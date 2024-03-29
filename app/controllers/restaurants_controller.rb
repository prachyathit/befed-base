class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:new, :edit, :update, :destroy]
  before_action :get_cart_size

  # GET /restaurants
  # GET /restaurants.json
  def index
    if session[:saddress].present? and session[:saddress][:raw].present? and
      session[:saddress][:raw][:latitude].present? and session[:saddress][:raw][:longitude].present?
      # @restaurants = Restaurant.all
      @restaurants = Restaurant.near([session[:saddress][:raw][:latitude], session[:saddress][:raw][:longitude]], 5, :units => :km)
    else
      redirect_to root_url
    end
  end

  def show
  # GET /restaurants/1
  # GET /restaurants/1.json def show
  end

  # GET /restaurants/new
  def new
    if params.include?(:latitude) or params.include?(:longitude) or params.include?(:address)
      params[:restaurant] ||= {}
      params[:restaurant][:latitude] ||= params[:latitude]
      params[:restaurant][:longitude] ||= params[:longitude]
      params[:restaurant][:address] ||= params[:address]
      @restaurant = Restaurant.new(restaurant_params)
    else
      @restaurant = Restaurant.new
    end
    @address = @restaurant
  end

  # GET /restaurants/1/edit
  def edit
    @restaurant_params = {}
    if params.include?(:latitude) or params.include?(:longitude) or params.include?(:address)
      params[:restaurant] ||= {}
      params[:restaurant][:latitude] ||= params[:latitude]
      params[:restaurant][:longitude] ||= params[:longitude]
      params[:restaurant][:address] ||= params[:address]
      @restaurant_params = params
      @restaurant.assign_attributes(restaurant_params)
    end
    p @restaurant.address
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    if params.include?(:latitude) or params.include?(:longitude) or params.include?(:address)
      params[:restaurant] ||= {}
      params[:restaurant][:latitude] ||= params[:latitude]
      params[:restaurant][:longitude] ||= params[:longitude]
      params[:restaurant][:address] ||= params[:address]
    end
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    if params.include?(:latitude) or params.include?(:longitude) or params.include?(:address)
      params[:restaurant] ||= {}
      params[:restaurant][:latitude] ||= params[:latitude]
      params[:restaurant][:longitude] ||= params[:longitude]
      params[:restaurant][:address] ||= params[:address]
    end
    respond_to do |format|
      @restaurant.assign_attributes(restaurant_params)
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit( :name, :desc, :image_url, :email, :dtime, :soon,
                                          :address, :latitude, :longitude, :min_order, :cday, :promo, :phone,
                                          :service_fee, category_ids: [])
    end

    # Only admin can do anything with resturants
    def check_admin
        redirect_to(root_url) unless user_admin?
    end
end
