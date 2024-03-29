require 'csv'
saladfactory_foods = Rails.root + "app/csv/SaladFactoryMenu.csv"
saladfactory_options = Rails.root + "app/csv/SaladFactoryOptions.csv"
saladfactory_option_values = Rails.root + "app/csv/SaladFactoryOptionValues.csv"
saladfactory_food_options = Rails.root + "app/csv/SaladFactoryFoodOptions.csv"
pakkred_place = Rails.root + "app/csv/PakkredPlace.csv"
namespace :data do

# Run these rake task in order to fill in all the menus and options for Salad Factory
  task load_dev_data: :environment do
    
    Restaurant.all.each do |restaurant|
      CSV.foreach(saladfactory_foods, :headers => true) do |row|
      restaurant.foods.create!(row.to_hash)
      end
    end

    CSV.foreach(saladfactory_options, :headers => true) do |row|
      Option.create!(row.to_hash)
    end

    CSV.foreach(saladfactory_option_values, :headers => true) do |row|
      OptionValue.create!(row.to_hash)
    end

    CSV.foreach(saladfactory_food_options, :headers => true) do |row|
      FoodOption.create!(row.to_hash)
    end
  end
  
  task delete_all_data: :environment do 
    Food.destroy_all
    Option.destroy_all
    OptionValue.destroy_all
    FoodOption.destroy_all
  end
  
  task load_place_data: :environment do
    CSV.foreach(pakkred_place, :headers => true) do |row|
      Place.create!(row.to_hash)
    end   
  end
  
  task :load_food_data, [:filename] => :environment do |task, args|
    fullname = Rails.root + "app/csv/" + args[:filename]
    CSV.foreach(fullname, :headers => true) do |row|
      Food.create!(row.to_hash)
    end  
  end
  
end
