class AddIndexToAlbumRating < ActiveRecord::Migration[5.1]
  def change
    add_index :album_ratings, [:user_id, :album_id], :unique => true
  end
end
