json.extract! song, :id, :name, :file_url, :album_id, :user_id, :created_at, :updated_at
json.url song_url(song, format: :json)
