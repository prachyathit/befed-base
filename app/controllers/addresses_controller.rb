class AddressesController < ApplicationController

  before_action :authenticate_user!
  before_action :get_current_address, 
    only: [:edit, :update, :show, :delete, :set_default]
 
  def index
   @addresses = current_user.addresses.order(updated_at: :desc)
  end

  def edit
  end

  def update
  end

  def new
    if params.include?(:latitude) and params.include?(:longitude)
      @address = Address.new(latitude: params[:latitude], 
        longitude: params[:longitude], instruction: params[:address])
    else
      @address = Address.new
    end
  end

  def create

  end

  def show
   
  end

  def delete
  end

  def set_default
    @address.user.set_default_address(@address)
    render json: { success: true, next_url: addresses_url }
  end

  private
  def get_current_address
    @address = Address.where(id: params[:id]).first
  end

end
