class AddPaymentTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_type, :integer, :default => 0
  end
end
