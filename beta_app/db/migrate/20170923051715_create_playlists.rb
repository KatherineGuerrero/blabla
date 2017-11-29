class CreatePlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :playlists do |t|
      t.string :name
      t.string :description
      t.boolean :private

      t.timestamps
    end
  end
end
