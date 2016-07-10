class AddRestIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :rest_id, :integer
  end
end
