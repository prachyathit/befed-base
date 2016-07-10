class OrderFood < ActiveRecord::Base
  belongs_to :order
  belongs_to :food
  
  def self.to_csv
    attributes = %w{id order_id rest_id food_id food_name food_cat quantity total}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      
      all.each do |orderfood|
        csv << orderfood.attributes.values_at(*attributes)
      end
    end
  end
end
