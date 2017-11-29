class CreateSongRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :song_ratings do |t|
      t.integer :user_id
      t.integer :song_id
      t.integer :rate

      t.timestamps
    end
  end
end
