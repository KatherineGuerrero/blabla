json.extract! playlist, :id, :name, :description, :private, :created_at, :updated_at
json.url playlist_url(playlist, format: :json)
