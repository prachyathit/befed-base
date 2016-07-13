class CreateOrderFoods < ActiveRecord::Migration
  def change
    create_table :order_foods do |t|
      t.integer :order_id
      t.integer :food_id

      t.timestamps null: false
    end
  end
end
