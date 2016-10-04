module OmiseGateway
  Omise.api_key = ENV['omise_secret_key']

  class << self
    def create_charge(order, token)
      charge = Omise::Charge.create({
        amount: (order.total * 100).to_i,
        currency: "thb",
        card: token
      })
      if charge.paid
        Rails.logger.info("Successfully paid by credit card")
        charge
      else
        Rails.logger.error("Unsuccessfully paid by credit card: #{charge.failure_code} #{charge.inspect}")
        raise ArgumentError, "Credit Card info is incorrect."
      end
    end
  end
end
