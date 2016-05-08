module OmiseGateway
  Omise.api_key = Rails.application.secrets.omise_secret_key

  class << self
    def create_charge(order, token)
      Omise::Charge.create({
        amount: order.total,
        currency: "thb",
        card: token
      })
    end
  end
end
