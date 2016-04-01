class FoodOption < ActiveRecord::Base
  belongs_to :food
  belongs_to :option
end
