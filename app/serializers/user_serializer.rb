class UserSerializer < ActiveModel::Serializer
	attributes :id, :name, :email, :default_address_id
	attribute :phone, key: :phone_no

	def default_address_id
		object.default_address.id
	end
end
