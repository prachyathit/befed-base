class AddressesController < ApplicationController

  before_action :authenticate_user!
  before_action :get_current_address, 
    only: [:edit, :update, :show, :destroy, :set_default]
 
  def index
   @addresses = current_user.addresses.order(updated_at: :desc)
  end

  def edit
    @address_params = {}
    if params.include?(:latitude) and params.include?(:longitude)
      params[:address][:latitude] = params[:latitude]
      params[:address][:longitude] = params[:longitude]
      @address_params = params
      @address.assign_attributes(address_params)
    end
  end

  def update
    @address.assign_attributes(address_params)
    if @address.save
      redirect_to edit_address_path(@address)
    else
      render :edit and return
    end
  end

  def new
    if params.include?(:latitude) and params.include?(:longitude)
      params[:address][:latitude] = params[:latitude]
      params[:address][:longitude] = params[:longitude]
      @address = Address.new(address_params)
    else
      @address = Address.new
    end
  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      if params[:return_url]
        redirect_to params[:return_url]+"?address_id=#{@address.id}"
      else
        redirect_to edit_address_path(@address)
      end
    else
      render :new and return
    end
  end

  def show
   
  end

  def destroy
    @address.destroy
    redirect_to addresses_path
  end

  def set_default
    @address.user.set_default_address(@address)
    render json: { success: true, next_url: addresses_url }
  end

  private

  def address_params
    params.require(:address).permit(:name, :latitude, :longitude, :user_id, 
      :house_room_no, :street, :building_name, :floor, :province, 
      :postal_code, :district, :subdistrict, :instruction)
  end

  def get_current_address
    @address = Address.where(id: params[:id]).first
  end

end
