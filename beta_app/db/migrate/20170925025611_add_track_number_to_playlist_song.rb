class AddTrackNumberToPlaylistSong < ActiveRecord::Migration[5.1]
  def change
    add_column :playlist_songs, :track_number, :integer
  end
end
