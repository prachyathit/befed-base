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
    rest_email = Restaurant.find(@order.rest_id).email
    subject_to_restaurant = "Befed Delivery Request Order number #{order.id}"
    mail to: rest_email, subject: subject_to_restaurant, from: "befedtoday@gmail.com"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
