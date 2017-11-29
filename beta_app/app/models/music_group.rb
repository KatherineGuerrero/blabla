class MusicGroup < ApplicationRecord
	has_many :albums, dependent: :destroy
	belongs_to :user
	validates :name, presence:true
	mount_uploader :profile_picture, MusicGroupProfilePictureUploader

	def get_path_to_show
      return "/music_groups/#{self.id}"
    end

	def get_profile_picture_path(v = 'raw')
        if self.profile_picture.file.nil?
            image = "music_group_profile_picture_default/group.png"
        else
			if v == 'thumbnail'
				image = self.profile_picture.url(:thumb).to_s
			else
				image = self.profile_picture.url.to_s
			end
        end
        return image
    end
end
