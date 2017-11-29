class RecommendationArtistMailer < ApplicationMailer
	default from: 'grupo20software@gmail.com'

	def recommendation_artist_email(user, music_group)
		@user = user
		@music_group = music_group
		@url = 'rails-practice-app-17.herokuapp.com'
		mail(to: @user.email, subject: 'Check out the new music group')
	end
end
