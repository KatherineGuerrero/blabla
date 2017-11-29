class AddColumnToPlaylistSong < ActiveRecord::Migration[5.1]
  def change
    add_column :playlist_songs, :playlist_id, :integer
    add_column :playlist_songs, :song_id, :integer
  end
end
