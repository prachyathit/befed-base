class Payment < ActiveRecord::Base
  CREDIT_CARD = 'credit_card'
  CASH = 'cash'
  
  belongs_to :user
  belongs_to :order
end
