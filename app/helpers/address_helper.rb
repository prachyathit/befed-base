module AddressHelper

  def thumb_class_for_address address
    if address.is_default
      "address-thumb default-address-thumb"
    else
      "address-thumb"
    end
  end
end
