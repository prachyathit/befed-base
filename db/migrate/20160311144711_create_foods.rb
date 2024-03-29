class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name
      t.integer :price
      t.string :image_url
      t.references :restaurant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
