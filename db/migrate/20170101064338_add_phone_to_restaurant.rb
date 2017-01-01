class AddPhoneToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :phone, :string, :default => "0922764769"
  end
end
