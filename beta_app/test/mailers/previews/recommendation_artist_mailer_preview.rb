# Preview all emails at http://localhost:3000/rails/mailers/recommendation_artist_mailer
class RecommendationArtistMailerPreview < ActionMailer::Preview
	def recommendation_artist_mail_preview
		RecommendationArtistMailer.recommendation_artist_email(User.first, MusicGroup.first)
	end
end
