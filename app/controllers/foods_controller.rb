class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:edit, :update, :destroy]

  # GET /foods
  # GET /foods.json
  def index
    @foods = current_restaurant.foods.all
    reset_cart
  end

  # GET /foods/1
  # GET /foods/1.json
  def show
  end

  # GET /foods/new
  def new
    @food = current_restaurant.foods.build
  end

  # GET /foods/1/edit
  def edit
  end

  # POST /foods
  # POST /foods.json
  def create
    @food = current_restaurant.foods.build(food_params)

    respond_to do |format|
      if @food.save
        format.html { redirect_to restaurant_foods_path, notice: 'Food was successfully created.' }
        format.json { render :show, status: :created, location: @food }
      else
        format.html { render :new }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
    respond_to do |format|

      if @food.update(food_params)
        format.html { redirect_to restaurant_food_url(id: @food.id), notice: 'Food was successfully updated.' }
        format.json { render :show, status: :ok, location: @food }
      else
        format.html { render :edit }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.json
  def destroy
    @food.destroy
    respond_to do |format|
      format.html { redirect_to restaurant_foods_url, notice: 'Food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = current_restaurant.foods.find(params[:id])
    end

    def current_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:name, :price, :image_url, :restaurant_id)
    end

    # If user changes restaurant, empty cart
    def reset_cart
      if session[:restaurant_id]
        unless session[:restaurant_id] == params[:restaurant_id]
          session[:cart] = nil
          session[:restaurant_id] = params[:restaurant_id]
        end
      else
        session[:restaurant_id] = params[:restaurant_id]
      end
    end

    # Only admin can do anything with foods
    def check_admin
        redirect_to(root_url) unless user_admin?
    end
end
