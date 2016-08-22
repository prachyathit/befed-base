class AddSoonToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :soon, :boolean, :default => false
  end
end
