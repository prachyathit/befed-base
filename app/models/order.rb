class Order < ActiveRecord::Base

  # Flat rate for delivery
  FLAT_RATE = 70 # Bahts

  belongs_to :user
  has_one :payment

  def self.process!(params)
    self.new.tap do |order|
      order.user = params[:user]
      order.total = calculate_order_total(params[:cart])
      order.save!
    end
  end

  private
  # Probably need to store some details about this order such as
  # food options, special instructions, and delivery instructions
  def self.calculate_order_total(cart)
    total = 0
    cart.each do |k, v|
      food = Food.find_by(id: v['food_id'])
      total += food.price * v['quantity'].to_i
    end
    total + FLAT_RATE
  end
end
