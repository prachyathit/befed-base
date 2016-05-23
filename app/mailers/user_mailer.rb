class UserMailer < ApplicationMailer

  def delivery_confirmation(user, cart, instruction)
    @user = user
    @cart = cart
    @instruction = instruction
    mail to: user.email, subject: "Delivery Confirmation"
  end

  def order_placed(user, cart, instruction)
    @user = user
    @cart = cart
    @instruction = instruction
    subject_to_us = "Order from #{user.name}"
    mail to: "befedtoday@gmail.com", subject: subject_to_us
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
