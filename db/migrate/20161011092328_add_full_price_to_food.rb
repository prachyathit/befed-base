class AddFullPriceToFood < ActiveRecord::Migration
  def change
    add_column :foods, :full_price, :integer, :default => 0
  end
end
