json.array!(@foods) do |food|
  json.extract! food, :id, :name, :price, :image_url, :restaurant_id, :cat_id, :cat
  json.url restaurant_foods_url(food, format: :json)
  
  json.options do
  json.array!(food.options) do |option|
    json.extract! option, :id, :name, :option_type
    json.option_values do
      json.array!(option.option_values) do |option_value|
        json.id option_value.id
        json.name option_value.name
        json.price option_value.price
      end
    end
  end
end
end
