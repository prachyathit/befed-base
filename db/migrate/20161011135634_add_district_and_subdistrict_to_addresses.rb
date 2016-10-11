class AddDistrictAndSubdistrictToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :district, :string
    add_column :addresses, :subdistrict, :string
  end
end
