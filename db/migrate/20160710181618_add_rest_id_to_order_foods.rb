class AddRestIdToOrderFoods < ActiveRecord::Migration
  def change
    add_column :order_foods, :rest_id, :integer
  end
end
