class RecommendationAlbumMailer < ApplicationMailer
	default from: 'grupo20software@gmail.com'

	def recommendation_album_email(user, album)
		@user = user
		@album = album
		@url = 'rails-practice-app-17.herokuapp.com'
		mail(to: @user.email, subject: 'Check out the new album')
	end
end
