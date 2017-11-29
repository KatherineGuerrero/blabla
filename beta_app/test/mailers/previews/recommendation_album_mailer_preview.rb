# Preview all emails at http://localhost:3000/rails/mailers/recommendation_album_mailer
class RecommendationAlbumMailerPreview < ActionMailer::Preview
	def recommendation_album_mail_preview
		RecommendationAlbumMailer.recommendation_album_email(User.first, Album.first)
	end
end
