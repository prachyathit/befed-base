json.array!(@restaurants) do |restaurant|
  json.extract! restaurant, :id, :name, :desc, :image_url
  json.url restaurant_url(restaurant, format: :json)
end
