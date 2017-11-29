class Song < ApplicationRecord
	belongs_to :user
	belongs_to :album

	validates :name, presence:true
	has_many :playlist_songs, dependent: :destroy
	has_many :playlists, through: :playlist_songs
	has_many :ratings, class_name: 'SongRating', foreign_key: 'song_id', dependent: :destroy

	has_many :user_favorite_songs, dependent: :destroy, class_name: "FavoriteSong", foreign_key: "song_id"
  has_many :favorited_users, through: :user_favorite_songs, :source => :user, dependent: :destroy


	def get_path_to_show
      return "/songs/#{self.id}"
    end

	def get_rating
 	 @rating = 0
 	 @total = 0
 	 for song_rate in self.ratings
 		 @total +=1
 		 @rating += song_rate.rate
 	 end

	 if @total >0
 	 	@rating /= @total.to_f
	 end

 	 return @rating
  end

end
