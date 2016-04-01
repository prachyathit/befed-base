class CreateFoodOptions < ActiveRecord::Migration
  def change
    create_table :food_options do |t|
      t.integer :food_id
      t.integer :option_id

      t.timestamps null: false
    end
  end
end
