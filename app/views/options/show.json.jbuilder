json.id @option.id
json.name @option.name

json.option_values do
    json.array!(@option.option_values) do |option_value|
        json.id option_value.id
        json.name option_value.name
        json.price option_value.price
    end
end

