class AddMinMaxToOptions < ActiveRecord::Migration
  def change
  	add_column :options, :min, :integer, default: 1
  	add_column :options, :max, :integer, default: 1
  end
end
