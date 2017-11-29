class UserMailer < ApplicationMailer
	default from: 'grupo20software@gmail.com'

	def welcome_email(user)
		# welcome_email takes user parameters and sends email
		# using method mail to email address of user
		@user = user
		@url = 'rails-practice-app-17.herokuapp.com'
		mail(to: @user.email, subject: 'Welcome to our site')
	end
end
