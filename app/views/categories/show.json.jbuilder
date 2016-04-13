json.extract! @category, :id, :name, :image_url, :created_at, :updated_at
json.array! @category_restaurants, :id, :name, :image_url, :created_at, :updated_at
