class Restaurant < ActiveRecord::Base
  has_many :foods, dependent: :destroy
  has_many :restaurant_categories
  has_many :categories, through: :restaurant_categories
  validates :name, presence: true
  default_scope -> { order(:id) }

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :reverse_geocode

  DELIVERY_RADIUS = 5

  def can_delivery_to_address?(latitude, longitude)
  	#Distance between current user and restuarant
  	distance = Geocoder::Calculations.distance_between(
  							[latitude, longitude], [self.latitude, self.longitude])
  	distance <= DELIVERY_RADIUS
  end

  def close_today?
    self.cday == Time.now.wday
  end
end
