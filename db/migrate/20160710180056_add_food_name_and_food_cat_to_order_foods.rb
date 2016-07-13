class AddFoodNameAndFoodCatToOrderFoods < ActiveRecord::Migration
  def change
    add_column :order_foods, :food_name, :string
    add_column :order_foods, :food_cat, :string
  end
end
