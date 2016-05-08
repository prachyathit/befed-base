class Payment::CreditCard < Payment
  before_validation :create_omise_charge, if: :new_record?

  attr_accessor :token

  private

  def create_omise_charge
    charge = OmiseGateway.create_charge(order, token)
    # save charge information
  end
end
