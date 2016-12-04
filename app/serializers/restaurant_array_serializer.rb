class RestaurantArraySerializer < ActiveModel::Serializer
	attributes :id, :name, :desc, :image_url, :min_order, :delivery_hours, 
		:close_today, :service_fee
	attribute :dtime, key: :delivery_time
	attribute :soon, key: :comming_soon

	def delivery_hours
		"11:00AM - 9:00PM"
	end

	def close_today
		object.close_today?
	end
end
