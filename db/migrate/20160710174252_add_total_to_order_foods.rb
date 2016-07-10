class AddTotalToOrderFoods < ActiveRecord::Migration
  def change
    add_column :order_foods, :total, :integer
  end
end
