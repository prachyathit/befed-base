json.array!(@options) do |option|
  json.extract! option, :id, :name, :position
  json.url option_url(option, format: :json)
end

