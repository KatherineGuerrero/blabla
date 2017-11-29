# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
	def welcome_mail_preview
		# We will just call any user (first 
		# user in this case) to preview the email
		UserMailer.welcome_email(User.first)
	end
end
