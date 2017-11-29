class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :profile_picture, ProfilePictureUploader
  belongs_to :role
  before_validation :set_default_role
  after_create :send_welcome_email

  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :confirmable, :recoverable

	has_many :posts , dependent: :destroy
	has_many :music_groups , dependent: :destroy
	has_many :albums , dependent: :destroy

	has_many :songs , dependent: :destroy
  has_many :playlists , dependent: :destroy

  has_many :ratings, dependent: :destroy,  class_name: "AlbumRating", foreign_key: "user_id"
  has_many :song_ratings, dependent: :destroy, class_name: "SongRating", foreign_key: "user_id"

  has_many :comments, dependent: :destroy,  class_name: "UserComment", foreign_key: "mentioned_id"
  has_many :writed_comments, dependent: :destroy, class_name: "UserComment", foreign_key: "author_id"

	validates :name, presence:true
	validates :email, presence:true
	# validates :password, presence:true


  has_many :user_follow_playlists, dependent: :destroy
  has_many :followed_playlists, through: :user_follow_playlists, :source => :playlist, dependent: :destroy

  # active_relationships allow to get followed users and passive_relationships
  # allow to get followers users

  has_many :user_favorite_songs, dependent: :destroy, class_name: "FavoriteSong", foreign_key: "user_id"
  has_many :favorited_songs, through: :user_favorite_songs, :source => :song, dependent: :destroy

  has_many :active_relationships, dependent: :destroy, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followed_users, through: :active_relationships, :source => :followed , dependent: :destroy

  has_many :passive_relationships, dependent: :destroy, class_name: "Relationship", foreign_key: "followed_id"
  has_many :followers, through: :passive_relationships, :source => :follower, dependent: :destroy



  def owns_playlist(playlist_id)
    self.playlists.each do |playlist|
      if playlist.id == playlist_id.to_i
        return true
      end
    end
  return false
  end

  #this code smells, fix if there's time
  def follows_playlist(playlist_id)
    self.followed_playlists.each do |playlist|
      if playlist.id == playlist_id.to_i
        return true
      end
    end
    return false
  end

  def get_profile_picture_path(v = 'raw')
      if self.profile_picture.file.nil?
          image = "users_profile_picture_default/musicdevil.png"
      else
          if v == 'thumbnail'
              image = self.profile_picture.url(:thumb).to_s
          else
              image = self.profile_picture.url.to_s
          end
      end
      return image
  end

  def has_rating(album_id)
      for rating in self.ratings
          if rating[:album_id] == album_id
            return true
          end
      end
      return false
  end

  def has_song_rating(song_id)
      for rating in self.song_ratings
          if rating[:song_id] == song_id
            return true
          end
      end
      return false
  end

  def followers_by_all()
      max = User.all.sort_by{|a| a.followers.length}.reverse![0].followers.length
      return self.followers.length * 100 / max
  end

  def get_path_to_show
    return "/users/#{self.id}"
  end

  def follow_user(other_user)
    self.followed_users << other_user
  end

  def unfollow_user(other_user)
    self.followed_users.delete(other_user)
  end

  def follow?(other_user)
    self.followed_users.include?(other_user)
  end

  def add_favorited_song(song)
    self.favorited_songs << song
  end

  def delete_favorited_song(song)
    self.favorited_songs.delete(song)
  end

  def favorited_song?(song)
    self.favorited_song.include?(song)
  end


  private
  def set_default_role
    self.role ||= Role.find_by_name('registered')
  end

  protected
  def confirmation_required?
    false
  end


  def send_welcome_email
    # if user exists not send email
    UserMailer.welcome_email(self).deliver
  end




end
