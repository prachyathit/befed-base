class AddCdayToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :cday, :integer
  end
end
