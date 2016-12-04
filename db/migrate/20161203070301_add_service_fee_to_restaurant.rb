class AddServiceFeeToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :service_fee, :integer, default: 0
  end
end
