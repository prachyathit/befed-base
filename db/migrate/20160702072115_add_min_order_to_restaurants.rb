class AddMinOrderToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :min_order, :integer, :default => 0
  end
end
