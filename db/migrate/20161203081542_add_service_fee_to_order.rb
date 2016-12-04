class AddServiceFeeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :service_fee_percent, :integer, default: 0
    add_column :orders, :service_fee, :float, default: 0
  end
end
