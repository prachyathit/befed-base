class OrderSerializer < ActiveModel::Serializer
	attributes :id, :total, :user_id, :restaurant_name, :created_at, :note
	attribute :rest_id, key: :restaurant_id

  def restaurant_name
    object.restaurant.name
  end

  def created_at
    object.created_at.strftime("%d %b %Y %H:%M")
  end
end
