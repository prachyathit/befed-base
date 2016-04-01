class OptionValue < ActiveRecord::Base
  belongs_to :option

  validates :name, presence: true
  validates :position, presence: true
end
