class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key
      t.string :value
      t.integer :value_type

      t.timestamps null: false
    end
  end
end
