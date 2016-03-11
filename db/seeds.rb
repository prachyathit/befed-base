User.create!( name: "Example User",
              email: "example@railstutorial.org",
              password: "foobar",
              password_confirmation: "foobar",
              admin: true )

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!( name: name,
                email: email,
                password: password,
                password_confirmation: password )
end

# restaurants
10.times do |n|
  name = Faker::Name.name
  description = Faker::Lorem.sentence(5)
  image_url = Faker::Internet.url
  Restaurant.create!( name: name,
                desc: description,
                image_url: image_url )
end

# foods
restaurants = Restaurant.order(:created_at).take(6)
10.times do
  name = Faker::Lorem.word
  price = Faker::Number.number(2)
  image_url = Faker::Internet.url

  restaurants.each do |restaurant|
    restaurant.foods.create!( name: name,
                              price: price,
                              image_url: image_url)
  end
end