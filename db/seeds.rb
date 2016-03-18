User.create!( name: "Example User",
              email: "example@railstutorial.org",
              phone: "0819999999",
              address: "Latphrao 90 Rd. Bangkok 10310",
              password: "foobar",
              password_confirmation: "foobar",
              admin: true )

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  phone = Faker::PhoneNumber.cell_phone
  address = Faker::Address.street_address + Faker::Address.city
  password = "password"
  User.create!( name: name,
                email: email,
                phone: phone,
                address: address,
                password: password,
                password_confirmation: password )
end

# Test restaurant
5.times do |n|
  name = "Test restaurant #{n+1}"
  description = Faker::Lorem.sentence(2)
  image_url = "http://i.imgur.com/Ox6fvZhm.png"
  Restaurant.create!( name: name,
                desc: description,
                image_url: image_url )
end

# Test foods

# restaurants
# 10.times do |n|
#   name = Faker::Name.name
#   description = Faker::Lorem.sentence(5)
#   image_url = Faker::Internet.url
#   Restaurant.create!( name: name,
#                 desc: description,
#                 image_url: image_url )
# end

# foods
restaurants = Restaurant.order(:created_at).take(6)
10.times do
  name = Faker::Lorem.word
  price = Faker::Number.number(2)
  image_url = "http://i.imgur.com/xcd5k92m.png"

  restaurants.each do |restaurant|
    cat_id = (1..4).to_a.sample
    case cat_id
    when 1
      cat = :Appetizer
    when 2
      cat = :Main
    when 3
      cat = :Dessert
    when 4
      cat = :Drinks
    else
      cat = ""
    end
    restaurant.foods.create!( name: name,
                              price: price,
                              image_url: image_url,
                              cat_id: cat_id,
                              cat: cat)
  end
end