class CreateRestaurantCategories < ActiveRecord::Migration
  def change
    create_table :restaurant_categories do |t|
      t.integer :restaurant_id
      t.integer :category_id
    end
  end
end
