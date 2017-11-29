class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.string :name
      t.integer :user_id
      t.integer :music_group_id
      t.date :release_date

      t.timestamps
    end
  end
end
