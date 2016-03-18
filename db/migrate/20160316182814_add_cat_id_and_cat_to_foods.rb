class AddCatIdAndCatToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :cat_id, :integer
    add_column :foods, :cat, :string
  end
end
