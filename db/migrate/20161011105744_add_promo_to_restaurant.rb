class AddPromoToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :promo, :boolean, :default => false
  end
end
