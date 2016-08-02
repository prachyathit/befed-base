class RestaurantSerializer < ActiveModel::Serializer
	attributes :id, :name, :desc, :image_url, :min_order, :address, :latitude, :longitude
end
