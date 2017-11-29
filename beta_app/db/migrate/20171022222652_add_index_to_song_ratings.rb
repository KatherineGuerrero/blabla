class AddIndexToSongRatings < ActiveRecord::Migration[5.1]
  def change
    add_index :song_ratings , [:user_id, :song_id], :unique => true
  end
end
