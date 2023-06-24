class ConfirmationMailer < ApplicationMailer
	def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My App')
  end
end

