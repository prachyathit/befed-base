class AddOptionStringToOrderFoods < ActiveRecord::Migration
  def change
    add_column :order_foods, :option_string, :string
  end
end
