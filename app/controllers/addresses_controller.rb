class AddressesController < ApplicationController

  before_action :authenticate_user!
  before_action :get_current_address, only: [:edit, :update, :show, :delete]
 
  def index
   @addresses = current_user.addresses
  end

  def edit
  end

  def new
    @address = Address.new
  end

  def show
   
  end

  def delete
  end

  private
  def get_current_address
    @address = Address.where(id: params[:id]).first
  end

end
