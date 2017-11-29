class CreateAlbumRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :album_ratings do |t|
      t.integer :user_id
      t.integer :album_id
      t.integer :rate

      t.timestamps
    end
  end
end
