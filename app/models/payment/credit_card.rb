class Payment::CreditCard < Payment
  before_validation :create_omise_charge, if: :new_record?

  attr_accessor :token

  private

  def create_omise_charge
  	charge = OmiseGateway.create_charge(order, token)
  	self.omise_charge_id = charge.id
    # may want to save extra information not sure but for now save charge_id (this is used for refund and other stuff)
  end
end
