class AddAppearToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :appear, :boolean, :default => true
  end
end
