class AddQuantityToOrderFoods < ActiveRecord::Migration
  def change
    add_column :order_foods, :quantity, :integer
  end
end
