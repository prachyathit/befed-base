json.array!(@foods) do |food|
  json.extract! food, :id, :name, :price, :image_url, :restaurant_id
  json.url restaurant_foods_url(food, format: :json)
end
