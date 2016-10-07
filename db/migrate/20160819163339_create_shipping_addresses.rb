class CreateShippingAddresses < ActiveRecord::Migration
  def change
    create_table :shipping_addresses do |t|
      t.integer :order_id
      t.text :address
      t.float :latitude
      t.float :longitude
      t.string :instruction

      t.timestamps null: false
    end
    add_index :shipping_addresses, :order_id
  end
end
