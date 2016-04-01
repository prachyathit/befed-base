class AddTypeToOptions < ActiveRecord::Migration
  def change
    add_column :options, :option_type, :integer
  end
end
