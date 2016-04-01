class AddPriceToOptionValues < ActiveRecord::Migration
  def change
    add_column :option_values, :price, :integer
  end
end
