class Album < ApplicationRecord
	belongs_to :music_group
	belongs_to :user
	has_many :songs , dependent: :destroy
	has_many :ratings, dependent: :destroy,  class_name: "AlbumRating", foreign_key: "album_id"
	validates :name, presence:true
	validate :release_date_cannot_be_in_the_past, :on => :create
	mount_uploader :cover, AlbumCoverUploader

	def release_date_cannot_be_in_the_past
		if release_date > Date.today
			errors.add(:release_date, " cannot be in the future")
		end
	end


	def get_album_cover_path(v = 'raw')
        if self.cover.file.nil?
            image = "album_cover_default/cd.png"
        else
			if v == 'thumbnail'
				image = self.cover.url(:thumb).to_s
			else
				image = self.cover.url.to_s
			end
        end
        return image
    end

	def get_path_to_show
      return "/albums/#{self.id}"
    end


	def get_rating
		@rating = 0
		@total = 0
		for album_rate in self.ratings
			@total += 1
			@rating += album_rate.rate
		end

		if @total > 0
			@rating /= @total.to_f
		end
		
		return @rating
	end
end
