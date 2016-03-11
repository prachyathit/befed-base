json.array!(@foods) do |food|
  json.extract! food, :id, :name, :price, :image_url, :restaurant_id
  json.url food_url(food, format: :json)
end
