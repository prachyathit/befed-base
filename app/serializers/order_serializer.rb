class OrderSerializer < ActiveModel::Serializer
	attributes :id, :total, :user_id, :note
	attribute :rest_id, key: :restaurant_id
end
