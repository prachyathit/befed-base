class UserMailer < ApplicationMailer

  def delivery_confirmation(user, cart, order)
    @user = user
    @cart = cart
    @order = order
    mail to: user.email, subject: "Delivery Confirmation from Befed"
  end

  def order_placed(user, cart, order)
    @user = user
    @cart = cart
    @order = order
    subject_to_us = "Order number #{order.id} from #{user.name}"
    mail to: "befedtoday@gmail.com", subject: subject_to_us
  end

  def delivery_request(user, cart, order)
    @user = user
    @cart = cart
    @order = order
    subject_to_restaurant = "Befed Delivery Request Order number #{order.id} from #{user.name}"
    mail to: "prachyathit.k@gmail.com", subject: subject_to_restaurant
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
