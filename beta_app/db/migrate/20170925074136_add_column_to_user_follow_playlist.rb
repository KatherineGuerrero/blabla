class AddColumnToUserFollowPlaylist < ActiveRecord::Migration[5.1]
    def change
      add_column :user_follow_playlists, :user_id, :integer
      add_column :user_follow_playlists, :playlist_id, :integer
      add_index :user_follow_playlists, [:user_id, :playlist_id], :unique => true
    end
end
