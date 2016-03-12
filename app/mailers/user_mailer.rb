class UserMailer < ApplicationMailer

  def delivery_confirmation(user, cart)
    @user = user
    @cart = cart
    mail to: user.email, subject: "Delivery Confirmation"
  end

  def order_placed(user, cart)
    @user = user
    @cart = cart
    subject_to_us = "Order from #{user.name}"
    mail to: "prachyathit.k@gmail.com", subject: subject_to_us
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
