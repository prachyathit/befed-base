class AddMinOrderToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :min_order, :integer
  end
end
