class Option < ActiveRecord::Base
  has_many :option_values, dependent: :destroy
  has_many :food_options
  has_many :options, through: :food_options

  def feed
    OptionValue.where("option_id = ?", id)
  end

end
