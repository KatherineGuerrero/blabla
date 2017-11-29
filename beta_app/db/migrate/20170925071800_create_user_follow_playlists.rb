class CreateUserFollowPlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :user_follow_playlists do |t|

      t.timestamps
    end
  end
end
