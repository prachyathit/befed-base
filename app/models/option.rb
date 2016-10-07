class Option < ActiveRecord::Base
  has_many :option_values, dependent: :destroy
  has_many :food_options
  has_many :options, through: :food_options
  
  validates :min, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :max }
  validates :max, numericality: { greater_than_or_equal_to: :min }

  def feed
    OptionValue.where("option_id = ?", id)
  end

end
