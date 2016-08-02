class RestaurantArraySerializer < ActiveModel::Serializer
	attributes :id, :name, :desc, :image_url, :min_order
end
