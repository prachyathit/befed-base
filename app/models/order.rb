class Order < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }
  # Flat rate for delivery
  # move flat rate to setting
  # FLAT_RATE = 50 # Bahts

  belongs_to :user
  belongs_to :restaurant, class_name: 'Restaurant', foreign_key: 'rest_id'
  has_one :payment
  has_one :shipping_address

  has_many :order_foods
  has_many :foods, through: :order_foods

  def self.process!(params)
    order = self.create! do |o|
      o.user = params[:user]
      o.rest_id = params[:rest_id]
      
      o.sub_total = calculate_item_total(params[:cart])
      
      restaurant = Restaurant.where(id: o.rest_id).first
      o.service_fee_percent = restaurant.service_fee
      o.service_fee = (o.service_fee_percent * o.sub_total / 100).ceil

      o.delivery_fee = params[:user].delivery_fee

      o.total = o.sub_total + o.service_fee + o.delivery_fee
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
    order.create_shipping_address!(address: address.full_address_with_name, latitude: address.latitude, 
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
          if option_value_id.is_a?(String) and option_value_id.present?
            option_value = OptionValue.find(option_value_id)
            food_price += option_value.price.to_i
            option_string = option_string + ", " + option_value.name
          elsif option_value_id.is_a?(Array) and option_value_id.size > 0
            option_value_id.each do |option_number|
              if option_number.present?
                option_value = OptionValue.find(option_number)
                food_price += option_value.price.to_i
                option_string = option_string + ", " + option_value.name
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
    attributes = %w{created_at id rest_id user_id sub_total delivery_fee service_fee total payment_type agent}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      
      all.each do |order|
        csv << order.attributes.values_at(*attributes)
      end
    end
  end
  
  def self.today
    where("created_at >= ?", Time.zone.now.beginning_of_day).select("DISTINCT(order_id)")
  end
  def self.yesterday
    where("created_at >= ?", Time.zone.now.beginning_of_day - 1.day).where("created_at < ?", Time.zone.now.beginning_of_day).select("DISTINCT(order_id)")
  end

  private
  # Probably need to store some details about this order such as
  # food options, special instructions, and delivery instructions
  def self.calculate_item_total(cart)
    subtotal = 0
    cart.deep_symbolize_keys!
    cart.each do |k, v|
      food = Food.find_by(id: v[:food_id])
      food_price = food.price
      
      options = v[:options]
      unless options.nil?
        options.each do |option|
          option_value_id = option[1][:option_value_ids]
          if option_value_id.is_a?(String) and option_value_id.present?
            option_value = OptionValue.find(option_value_id)
            food_price += option_value.price.to_i
          elsif option_value_id.is_a?(Array) and option_value_id.size > 0
            option_value_id.each do |option_number|
              if option_number.present?
                option_value = OptionValue.find(option_number)
                food_price += option_value.price.to_i
              end
            end
          end
        end
      end
      subtotal += food_price * v[:quantity].to_i
    end
    subtotal
  end
  
end
