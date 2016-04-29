require 'csv'
saladfactory_foods = Rails.root + "app/csv/SaladFactoryMenu.csv"
saladfactory_options = Rails.root + "app/csv/SaladFactoryOptions.csv"
saladfactory_option_values = Rails.root + "app/csv/SaladFactoryOptionValues.csv"
saladfactory_food_options = Rails.root + "app/csv/SaladFactoryFoodOptions.csv"
namespace :gen_menu do

# Run these rake task in order to fill in all the menus and options for Salad Factory  
  desc "Generate Menu"
  task menu: :environment do
    Restaurant.all.each do |restaurant|
      CSV.foreach(saladfactory_foods, :headers => true) do |row|
      restaurant.foods.create!(row.to_hash)
      end
    end
  end

  desc "Generate Options"
  task option: :environment do
    CSV.foreach(saladfactory_options, :headers => true) do |row|
    Option.create!(row.to_hash)
    end
  end

  desc "Generate Option Values"
  task option_value: :environment do
    CSV.foreach(saladfactory_option_values, :headers => true) do |row|
    OptionValue.create!(row.to_hash)
    end
  end
  
  desc "Generate Food Options table"
  task food_option: :environment do
    CSV.foreach(saladfactory_food_options, :headers => true) do |row|
    FoodOption.create!(row.to_hash)
    end
  end
  
end
