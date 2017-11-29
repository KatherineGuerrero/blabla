json.extract! music_group, :id, :name, :user_id, :bio, :created_at, :updated_at
json.url music_group_url(music_group, format: :json)
