class AddMinMaxToOptions < ActiveRecord::Migration
  def change
  	add_column :options, :min, :integer
  	add_column :options, :max, :integer
  end
end
