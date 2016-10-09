class AddDhourToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :dhour, :string, default: "11:00AM - 9:00PM"
  end
end
