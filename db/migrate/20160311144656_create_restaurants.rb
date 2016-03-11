class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :desc
      t.string :image_url

      t.timestamps null: false
    end
  end
end
