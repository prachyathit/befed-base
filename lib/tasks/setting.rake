namespace :setting do

  desc "init default setting"
  task init: :environment do
    Setting.set(:delivery_fee, 50, :integer)
    Setting.set(:first_order_free_delivery, true, :boolean)
  end

end
