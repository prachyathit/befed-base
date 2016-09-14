class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.integer :user_id
      t.boolean :is_default, default: false
      t.float :latitude
      t.float :longitude
      t.text :instruction
      t.string :house_room_no
      t.string :street
      t.string :building_name
      t.string :floor
      t.string :province
      t.string :postal_code

      t.timestamps null: false
    end
    add_index :addresses, :user_id
    add_index :addresses, [:user_id, :is_default]
  end
end
