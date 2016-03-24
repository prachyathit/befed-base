class Restaurant < ActiveRecord::Base
  has_many :foods, dependent: :destroy
  has_many :restaurant_categories
  has_many :categories, through: :restaurant_categories
  validates :name, presence: true
end
