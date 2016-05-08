class AddRecToFood < ActiveRecord::Migration
  def change
    add_column :foods, :rec, :integer
  end
end
