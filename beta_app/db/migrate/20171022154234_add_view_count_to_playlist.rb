class AddViewCountToPlaylist < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :view_count, :integer, default: 0
  end
end
