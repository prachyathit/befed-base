class UserSerializer < ActiveModel::Serializer
	attributes :id, :name, :email, :address, :latitude, :longitude
	attribute :phone, key: :phone_no
	attribute :dinstruction, key: :delivery_instruction
end
