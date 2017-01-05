User.create!( name: "Example User",
              email: "example@railstutorial.org",
              phone: "0819999999",
              address: "ซอย ลาดพร้าว 90 แขวง พลับพลา เขต วังทองหลาง กรุงเทพมหานคร 10312 ประเทศไทย",
              latitude: 13.909736,
              longitude: 100.549625,
              password: "foobar0898318806",
              password_confirmation: "foobar0898318806",
              admin: true )

# 5.times do |n|
#   name = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   phone = Faker::PhoneNumber.cell_phone
#   address = Faker::Address.street_address + Faker::Address.city
#   password = "password"
#   User.create!( name: name,
#                 email: email,
#                 phone: phone,
#                 address: address,
#                 password: password,
#                 password_confirmation: password )
# end

# Branch 1
  name = "Salad Factory Beehive"
  description = "At Salad Factory, only finest ingredients are user. Especially the
                Quality of meat that is selected through the clean and state-of-the-art
                feeding and production process. Every ingredient can be checked back to
                its source to guarantee fresh, clean and safe food. We serve you only the
                best as we always do for our family."
  image_url = "https://s3-ap-southeast-1.amazonaws.com/befed-alpha/Salad+Factory/logo2.jpg"
  address = "Soi Mu Ban Mueang Thong Thani Khrongkan 6 Zone A, Tambon Ban Mai, Amphoe Pak Kret, Chang Wat Nonthaburi 11120, Thailand"

  min_order = 200
  Restaurant.create!( name: name,
                desc: description,
                latitude: 13.909736,
                longitude: 100.549625,
                image_url: image_url,
                address: address,
                min_order: min_order)

# Branch 2
  # name = "Salad Factory Robinson Srisaman"
  # description = "At Salad Factory, only finest ingredients are user. Especially the
  #               Quality of meat that is selected through the clean and state-of-the-art
  #               feeding and production process. Every ingredient can be checked back to
  #               its source to guarantee fresh, clean and safe food. We serve you only the
  #               best as we always do for our family."
  # image_url = "https://s3-ap-southeast-1.amazonaws.com/befed-alpha/Salad+Factory/logo2.jpg"
  # address = "Thanon Srisaman, Tambon Ban Mai, Amphoe Pak Kret, Chang Wat Nonthaburi 11120, Thailand"
  # Restaurant.create!( name: name,
  #               desc: description,
  #               image_url: image_url,
  #               address: address)

# Branch 3
  # name = "Salad Factory The Crystal"
  # description = "At Salad Factory, only finest ingredients are user. Especially the
  #               Quality of meat that is selected through the clean and state-of-the-art
  #               feeding and production process. Every ingredient can be checked back to
  #               its source to guarantee fresh, clean and safe food. We serve you only the
  #               best as we always do for our family."
  # image_url = "https://s3-ap-southeast-1.amazonaws.com/befed-alpha/Salad+Factory/logo2.jpg"
  # address = "205 Pradit Manutham Road, Khwaeng Lat Phrao, Khet Lat Phrao, Krung Thep Maha Nakhon 10230, Thailand"
  # Restaurant.create!( name: name,
  #               desc: description,
  #               image_url: image_url,
  #               address: address)

# # 4 Restaurant
#   name = "Georgetown Cupcake"
#   description = "Number 1 cupcake in town"
#   image_url = "http://i.imgur.com/XAjdLvS.jpg?1"
#   Restaurant.create!( name: name,
#                 desc: description,
#                 image_url: image_url )

# # 5 Restaurant
#   name = "Lifestyle Juicery"
#   description = "100% cold pressed juice on demand"
#   image_url = "http://i.imgur.com/5eKvfqY.jpg?1"
#   Restaurant.create!( name: name,
#                 desc: description,
#                 image_url: image_url )
# # 6 Restaurant
#   name = "Juniper Sushi"
#   description = "Cheap sushi"
#   image_url = "http://i.imgur.com/RR3A02c.jpg?1"
#   Restaurant.create!( name: name,
#                 desc: description,
#                 image_url: image_url )

# Create some categories
# Category.create!( name: "Healthy",
#                   image_url: "https://i.imgur.com/lVGYkOW.jpg?1")
# Category.create!( name: "Thai",
#                   image_url: "https://i.imgur.com/nMzNKxo.jpg?1")
# Category.create!( name: "Noodles",
#                   image_url: "https://i.imgur.com/R2s7oM5.jpg?1")
# Category.create!( name: "Japanese",
#                   image_url: "https://i.imgur.com/RR3A02c.jpg?1")
# Category.create!( name: "Desserts",
#                   image_url: "https://i.imgur.com/GrNPRhU.jpg?1")
# Category.create!( name: "Drinks",
#                   image_url: "https://i.imgur.com/cf7SXbV.jpg?1")
