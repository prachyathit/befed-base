class AddSubTotalToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :sub_total, :float
  end
end
