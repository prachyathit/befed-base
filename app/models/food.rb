class Food < ActiveRecord::Base
  belongs_to :restaurant

  has_many :food_options
  has_many :options, through: :food_options

  has_many :order_foods
  has_many :orders, through: :order_foods

  scope :by_cat, -> { order(cat_id: :asc, id: :asc) }

  def thai_name
  	self.name.split(" : ")[1]
  end

  def eng_name
  	self.name.split(" : ")[0]
  end
end
