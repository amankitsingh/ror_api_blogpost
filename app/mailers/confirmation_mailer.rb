class ConfirmationMailer < ApplicationMailer
	def welcome_email(user)
    @user = user
		@api_secret = user.api_secrets.last
    mail(to: @user.email, subject: 'Welcome to My App')
  end
end

