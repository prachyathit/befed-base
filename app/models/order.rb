class Order < ActiveRecord::Base
  default_scope -> { order(:id) }
  # Flat rate for delivery
  FLAT_RATE = 50 # Bahts

  belongs_to :user
  has_one :payment
  has_one :shipping_address

  has_many :order_foods
  has_many :foods, through: :order_foods

  def self.process!(params)
    order = self.create! do |o|
      o.user = params[:user]
      o.rest_id = params[:rest_id]
      o.total = calculate_order_total(params[:cart], params[:first_order])
      if params[:payment_type] == Payment::CREDIT_CARD
        o.payment_type = 1
      else
        o.payment_type = 0
      end
    end
    user = order.user
    if params[:address_id]
      address = user.addresses.where(id: params[:address_id]).first
    else
      address = user.default_address
    end
    # TODO: change user.address to address.full_address when website with multiple address launched
    order.create_shipping_address!(address: user.address, latitude: address.latitude, 
        longitude: address.longitude, instruction: address.instruction)
    order
  end
  
  def create_order_food(cart)
    cart.deep_symbolize_keys!
    cart.each do |k,v|
      food = Food.find_by(id: v[:food_id])
      food_price = food.price
      food_name = food.name
      food_cat = food.cat
      quantity = v[:quantity].to_i
      option_string = ""
      options = v[:options]
      unless options.nil?
        options.each do |option|
          option_value_id = option[1][:option_value_ids]
          unless option_value_id.first.empty?
            if option_value_id.class == String
              option_value = OptionValue.find(option_value_id)
              food_price += option_value.price.to_i
              option_string = option_string + ", " + option_value.name
            else
              option_value_id.each do |option_number|
                unless option_number.empty?
                  option_value = OptionValue.find(option_number)
                  food_price += option_value.price.to_i
                  option_string = option_string + ", " + option_value.name
                end
              end
            end
          end
        end
      end
      option_string = option_string + ", " + v[:special]
      total = food_price * quantity
      OrderFood.create!(order_id: self.id, rest_id: self.rest_id, food_id: v[:food_id], food_name: food_name, option_string: option_string, food_cat: food_cat, quantity: quantity, total: total)
    end
  end
  
  def self.to_csv
    attributes = %w{id rest_id user_id total payment_type created_at note}
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
    cart.deep_symbolize_keys!
    cart.each do |k, v|
      food = Food.find_by(id: v[:food_id])
      food_price = food.price
      
      options = v[:options]
      unless options.nil?
        options.each do |option|
          option_value_id = option[1][:option_value_ids]
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
      total += food_price * v[:quantity].to_i
    end
    unless first_order
      total + FLAT_RATE
    else 
      total
    end
  end
  
end
