class PaymentMethod::CreditCard < PaymentMethod
  before_validation :check_for_omise_customer, on: :create
  before_validation :create_omise_payment_method, on: :create

  attr_accessor :card_token

  private

  def check_for_omise_customer
    return user.find_or_create_omise_customer(card_token) if user.find_or_create_omise_customer(card_token)
    # add error message or whatever here
    false
  end

  def create_omise_payment_method
    response = OmiseGateway.create_payment_method(card_token, user.omise_customer_id)
  end
end
