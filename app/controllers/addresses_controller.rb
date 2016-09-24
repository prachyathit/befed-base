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
    @address = Address.new
  end

  def create
  end

  def show
   
  end

  def delete
  end

  def set_default
    @address.user.set_default_address(@address)
    redirect_to addresses_path
  end

  private
  def get_current_address
    @address = Address.where(id: params[:id]).first
  end

end
