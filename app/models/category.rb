class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :image_url, presence: true
  has_many :restaurant_categories
  has_many :restaurants, through: :restaurant_categories
  default_scope -> { order(:id) }
end
