class RestaurantSerializer < ActiveModel::Serializer
	attributes :id, :name, :desc, :image_url, :min_order, :address, 
		:latitude, :longitude, :delivery_hours
	attribute :dtime, key: :delivery_time

	def delivery_hours
		"11:00AM - 9:00PM"
	end

end
