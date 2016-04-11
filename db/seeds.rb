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

# First Restaurant
  name = "ร้านอาหารไทย"
  description = "ข้าวผัด ผัดไทย"
  image_url = "http://i.imgur.com/JuF96zV.jpg"
  Restaurant.create!( name: name,
                desc: description,
                image_url: image_url )

# Test restaurant
4.times do |n|
  name = "Test restaurant #{n+2}"
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

# menus for first restaurant
first_restaurant = Restaurant.first
    first_restaurant.foods.create!( name: "ทอดมันกุ้ง",
                              price: 80,
                              image_url: "http://i.imgur.com/IACZyI2.jpg",
                              cat_id: 1,
                              cat: "Appetizer")
    first_restaurant.foods.create!( name: "เอ็นข้อไก่ทอด",
                              price: 65,
                              image_url: "http://i.imgur.com/pmHhIJo.jpg",
                              cat_id: 1,
                              cat: "Appetizer")
    first_restaurant.foods.create!( name: "เฟร้นช์ฟราย",
                              price: 70,
                              image_url: "http://i.imgur.com/mf8Bw9v.jpg",
                              cat_id: 1,
                              cat: "Appetizer")
    first_restaurant.foods.create!( name: "ถั่วทอด",
                              price: 60,
                              image_url: "http://i.imgur.com/P42ocKJ.jpg",
                              cat_id: 1,
                              cat: "Appetizer")
    first_restaurant.foods.create!( name: "ข้าวกะเพราไก่ไข่ดาว",
                              price: 60,
                              image_url: "http://i.imgur.com/kgFexop.jpg",
                              cat_id: 2,
                              cat: "Main")
    first_restaurant.foods.create!( name: "ข้าวผัดปู",
                              price: 85,
                              image_url: "http://i.imgur.com/P42ocKJ.jpg",
                              cat_id: 2,
                              cat: "Main")
    first_restaurant.foods.create!( name: "ก๋วยเตี๋ยวคั่วไก่",
                              price: 50,
                              image_url: "http://i.imgur.com/p9CN3OT.jpg",
                              cat_id: 2,
                              cat: "Main")
    first_restaurant.foods.create!( name: "ผัดไทย",
                              price: 65,
                              image_url: "http://i.imgur.com/gQCT7de.jpg",
                              cat_id: 2,
                              cat: "Main")
    first_restaurant.foods.create!( name: "ผัดซีอิ้ว",
                              price: 55,
                              image_url: "http://i.imgur.com/DC9dXR9.jpg",
                              cat_id: 2,
                              cat: "Main")
    first_restaurant.foods.create!( name: "ราดหน้า",
                              price: 60,
                              image_url: "http://i.imgur.com/vSUipNJ.jpg",
                              cat_id: 2,
                              cat: "Main")
    first_restaurant.foods.create!( name: "ฮันนี่โทสต์",
                              price: 70,
                              image_url: "http://i.imgur.com/3eYz596.jpg",
                              cat_id: 3,
                              cat: "Dessert")
    first_restaurant.foods.create!( name: "ครีมบรูเล่",
                              price: 60,
                              image_url: "http://i.imgur.com/woNzoGQ.jpg",
                              cat_id: 3,
                              cat: "Dessert")
    first_restaurant.foods.create!( name: "คัสตาร์ด",
                              price: 50,
                              image_url: "http://i.imgur.com/SWHQIwB.jpg",
                              cat_id: 3,
                              cat: "Dessert")
# menu for other restaurants
restaurants = Restaurant.where( :id => 2..5 )
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

# Create some categories
Category.create!( name: "Healthy",
                  image_url: "http://i.imgur.com/k2Q0rRv.jpg")
Category.create!( name: "Thai",
                  image_url: "http://i.imgur.com/bUxrlBe.jpg")
Category.create!( name: "Noodles",
                  image_url: "http://i.imgur.com/fZ3itxr.jpg")
Category.create!( name: "Japanese",
                  image_url: "http://i.imgur.com/0Fo30Rv.jpg")
Category.create!( name: "Desserts",
                  image_url: "http://i.imgur.com/ZiPkZSd.jpg")
Category.create!( name: "Drinks",
                  image_url: "http://i.imgur.com/ZiPkZSd.jpg")
