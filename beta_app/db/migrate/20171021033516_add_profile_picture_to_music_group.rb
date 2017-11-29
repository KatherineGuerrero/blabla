class AddProfilePictureToMusicGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :music_groups, :profile_picture, :string
  end
end
