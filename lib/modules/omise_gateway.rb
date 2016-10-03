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
        # handle success
        puts "thanks"
        Rails.logger.info("Paid SUCCESSFULLY")
      else
        # handle failure
        Rails.logger.error("#{charge.failure_code} #{charge.inspect}")
        raise charge.failure_code
      end
    end
  end
end
