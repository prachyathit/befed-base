class AddDinstructionToUser < ActiveRecord::Migration
  def change
    add_column :users, :dinstruction, :text
  end
end
