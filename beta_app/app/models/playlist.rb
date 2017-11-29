class Playlist < ApplicationRecord
    belongs_to :user

    has_many :playlist_songs, -> { order(track_number: :asc) }, dependent: :destroy
    has_many :songs, through: :playlist_songs

    has_many :user_follow_playlists, dependent: :destroy
    has_many :followers, through: :user_follow_playlists, :source => :user, dependent: :destroy

    validates :name, presence: true

    def has_song(song)
      for playlist_song in self.playlist_songs
        if playlist_song.song_id == song.id
          return true
        end
      end
      return false
    end

    def followers_by_all()
        max = Playlist.all.sort_by{|a| a.followers.length}.reverse![0].followers.length
        return self.followers.length * 100 / max
    end

    def track_number(song)
      for playlist_song in self.playlist_songs
        if playlist_song.song_id == song.id
          return playlist_song.track_number
        end
      end
    end

    def get_path_to_show
      return "/playlists/#{self.id}"
    end

end
