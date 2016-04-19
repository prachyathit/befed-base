class AddAddressToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :address, :text
    add_column :restaurants, :latitude, :float
    add_column :restaurants, :longitude, :float
  end
end
