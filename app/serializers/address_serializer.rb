class AddressSerializer < ActiveModel::Serializer
	attributes :id, :name, :is_default, :latitude, :longitude, 
		:instruction, :house_room_no, :street, :building_name, 
		:floor, :province, :postal_code
end
