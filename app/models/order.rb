class Order < ActiveRecord::Base
  default_scope -> { order(:id) }
  # Flat rate for delivery
  FLAT_RATE = 50 # Bahts

  belongs_to :user
  has_one :payment

  def self.process!(params)
    self.new.tap do |order|
      order.user = params[:user]
      order.rest_id = params[:rest_id]
      order.total = calculate_order_total(params[:cart], params[:first_order])
      if params[:payment_type]
        order.payment_type = 1
      else
        order.payment_type = 0
      end
      order.save!
    end
  end
  
  def self.to_csv
    attributes = %w{id total payment_type created_at}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      
      all.each do |order|
        csv << order.attributes.values_at(*attributes)
      end
    end
  end

  private
  # Probably need to store some details about this order such as
  # food options, special instructions, and delivery instructions
  def self.calculate_order_total(cart, first_order)
    total = 0
    cart.each do |k, v|
      food = Food.find_by(id: v['food_id'])
      food_price = food.price
      
      options = v["options"]
      unless options.nil?
        options.each do |option|
          option_value_id = option[1]["option_value_ids"]
          unless option_value_id.first.empty?
            if option_value_id.class == String
              option_value = OptionValue.find(option_value_id)
              food_price += option_value.price.to_i
            else
              option_value_id.each do |option_number|
                unless option_number.empty?
                  option_value = OptionValue.find(option_number)
                  food_price += option_value.price.to_i
                end
              end
            end
          end
        end
      end
      total += food_price * v['quantity'].to_i
    end
    unless first_order
      total + FLAT_RATE
    else 
      total
    end
  end
end
