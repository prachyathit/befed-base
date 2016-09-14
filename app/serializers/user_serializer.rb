class UserSerializer < ActiveModel::Serializer
	attributes :id, :name, :email, :default_address_id
	attribute :phone, key: :phone_no

	def default_address_id
		if object.default_address.present?
			object.default_address.id
		else
			nil
		end
	end
end
