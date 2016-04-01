class Food < ActiveRecord::Base
  belongs_to :restaurant

  has_many :food_options
  has_many :options, through: :food_options

  scope :by_cat, -> { order(cat_id: :asc) }
end
