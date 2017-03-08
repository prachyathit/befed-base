class AddAgentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :agent, :string, :default => "Ray"
  end
end
