class AddOrderRelatedTables < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.text :omise_charge_id
      t.timestamps
    end

    create_table :orders do |t|
      t.decimal :total
      t.integer :payment_id
      t.timestamps
    end
  end
end
