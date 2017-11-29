class CreateMusicGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :music_groups do |t|
      t.string :name
      t.integer :user_id
      t.text :bio

      t.timestamps
    end
  end
end
