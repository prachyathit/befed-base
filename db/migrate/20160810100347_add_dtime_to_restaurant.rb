class AddDtimeToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :dtime, :integer
  end
end
