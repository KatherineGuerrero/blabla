class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :name
      t.string :file_url
      t.integer :album_id
      t.integer :user_id

      t.timestamps
    end
  end
end
