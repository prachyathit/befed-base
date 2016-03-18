class Food < ActiveRecord::Base
  belongs_to :restaurant
  scope :by_cat, -> { order(cat_id: :asc) }
end
