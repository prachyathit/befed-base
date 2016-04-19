class Restaurant < ActiveRecord::Base
  has_many :foods, dependent: :destroy
  has_many :restaurant_categories
  has_many :categories, through: :restaurant_categories
  validates :name, presence: true
  default_scope -> { order(:id) }

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :reverse_geocode
end
