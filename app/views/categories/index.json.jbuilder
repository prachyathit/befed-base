json.array!(@categories) do |category|
  json.extract! category, :id, :name, :image_url
  json.url category_url(category, format: :json)
end
