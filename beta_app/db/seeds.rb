# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'rspotify'

['registered',  'admin'].each do |role|
  Role.find_or_create_by({name: role})
end

# users = User.create([{email: 'Admin@admin.com', name: 'Admin', password: '654321',
# 					password_confirmation: '654321', role_id: '2'}])

# Usuarios admins
users = User.create([{email: 'kfguerrero@uc.cl', name: 'Katherine Guerrero', password: '654321',
					password_confirmation: '654321', role_id: '2'}])

users = User.create([{email: 'fipaniagua@uc.cl', name: 'Francisco Paniagua', password: '654321',
					password_confirmation: '654321', role_id: '2'}])

users = User.create([{email: 'dfandai@uc.cl', name: 'Diego Andai', password: '654321',
					password_confirmation: '654321', role_id: '2'}])

# Usuarios normales
users = User.create([{email: 'kt.94.jb@gmail.com', name: 'Katherine Guerrero', password: '123456',
					password_confirmation: '123456', role_id: '1'}])

users = User.create([{email: 'pani24@gmail.com', name: 'Francisco Paniagua', password: '123456',
					password_confirmation: '123456', role_id: '1'}])

users = User.create([{email: 'diego24@gmail.com', name: 'Diego Andai', password: '123456',
					password_confirmation: '123456', role_id: '1'}])

users = User.create([{email: 'claudia-3@gmail.com', name: 'Claudia Calderón', password: '123456',
					password_confirmation: '123456', role_id: '1'}])

users = User.create([{email: 'claudia-3@gmail.com', name: 'Claudia Calderón', password: '123456',
					password_confirmation: '123456', role_id: '1'}])

# usuarios count: 8
# Usuarios random
for i in 1..10
	u_name = Faker::Name.first_name
	last_name = Faker::Name.last_name
	email = u_name + '-' + rand(1...30).to_s
	users = User.create([{email: (email + '@gmail.com'), name: u_name, password: '123456',
					password_confirmation: '123456', role_id: '1'}])
end

# usuarios count: 18

for i in 1..10
	u_name = Faker::Name.first_name
	last_name = Faker::Name.last_name
	email = u_name + '-' + last_name + rand(80...99).to_s
	users = User.create([{email: (email + '@yahoo.com'), name: u_name, password: '123456',
					password_confirmation: '123456', role_id: '1'}])
end

# usuarios count: 28

# ########################################################
# MUSIC GROUPS
# #########################################################
music_groups = MusicGroup.create([{name: 'Jonas Brothers', user_id: '5',
					bio: 'The Jonas Brothers were an American rock and pop rock band. Formed in 2005...'}])

music_groups = MusicGroup.create([{name: 'Phoenix', user_id: '5',
					bio: 'Phoenix is an indie pop band from Versailles, France, consisting of Thomas Mars...'}])

music_groups = MusicGroup.create([{name: 'Twenty One Pilots', user_id: '6',
					bio: 'Twenty One Pilots is an American musical duo originating from Columbus, Ohio...'}])

# ########################################################
# ALBUMS
# #########################################################
albums = Album.create([{name: 'Vessel', user_id: '6', music_group_id: '3',
						release_date: '2013-09-27'}])

albums = Album.create([{name: 'Blurryface', user_id: '6', music_group_id: '3',
						release_date: '2015-09-27'}])

albums = Album.create([{name: 'United', user_id: '5', music_group_id: '2',
						release_date: '2000-09-27'}])

albums = Album.create([{name: 'Alphabetical', user_id: '5', music_group_id: '2',
						release_date: '2003-09-27'}])

albums = Album.create([{name: 'Lines, Vines and Trying Times', user_id: '5', music_group_id: '1',
						release_date: '2009-09-27'}])

new_releases_list = RSpotify::Album.new_releases(country: 'US', limit: 30)
new_releases_list.each do |album_instance|
	if album_instance.album_type == "album"
		u_id = rand(1..28)
		m_group_instance = album_instance.artists.first
		m_group_name = m_group_instance.name
		m_group_genre = m_group_instance.genres.first
		m_group_bio = "Famous artist of genre " + m_group_genre
		music_group_db = MusicGroup.create([{name: m_group_name, user_id: u_id,
					bio: m_group_bio}])
		m_group_id = MusicGroup.all.last.id

		a_name = album_instance.name
		a_release = album_instance.release_date
		album_db = Album.create([{name: m_group_name, user_id: u_id, music_group_id: m_group_id,
						release_date: a_release}])
		album_db_id = Album.all.last.id

		album_songs = album_instance.tracks(limit: 10, offset:0)
		album_songs.each do |track_instance|
			songs = Song.create([{name: track_instance.name, file_url: (track_instance.name + '.mp3'),
						album_id: album_db_id, user_id: u_id}])
		end
	end	
end

# ########################################################
songs = Song.create([{name: 'Ode to Sleep', file_url: 'ode_to_sleep.mp3',
						album_id: '1', user_id: '6'}])

songs = Song.create([{name: 'Holding On to You', file_url: 'holding_on_to_you.mp3',
						album_id: '1', user_id: '6'}])

songs = Song.create([{name: 'Migraine', file_url: 'migraine.mp3',
						album_id: '2', user_id: '6'}])

songs = Song.create([{name: 'Paranoid', file_url: 'Paranoid.mp3',
						album_id: '5', user_id: '5'}])

songs = Song.create([{name: 'Fly with Me', file_url: 'fly_with_me.mp3',
						album_id: '5', user_id: '5'}])

songs = Song.create([{name: 'Black Keys', file_url: 'black_keys.mp3',
						album_id: '5', user_id: '5'}])

songs = Song.create([{name: 'Before the Storm', file_url: 'before_storm.mp3',
						album_id: '5', user_id: '3'}])

#####################################################################

posts = Post.create([{content: 'I love Jonas Brothers music', user_id: '6'}])

posts = Post.create([{content: "I can't stop listening to Vessel, is amazing", user_id: '4'}])

posts = Post.create([{content: 'Oh I totally hate the new album of Phoenix', user_id: '7'}])

posts = Post.create([{content: 'I liked much better Phoenix old music too', user_id: '1'}])

posts = Post.create([{content: 'Omg I have to upload Sorry of the Jonas Brothers', user_id: '2'}])

posts = Post.create([{content: 'Why nobody has uploaded Taylor Swift albums?', user_id: '3'}])

posts = Post.create([{content: "Oh there is not even one rap song in this site", user_id: '5'}])

#####################################################################

playlists = Playlist.create([{name: "BestOfPop", description: 'Music that I love', private: 'f',
							  user_id: '2' }])

playlists = Playlist.create([{name: "BestToSLeep", description: 'To sleep better music', private: 'f',
							  user_id: '5' }])

# Creo playlists
for i in 1...8
	na = Faker::Movie.quote
	des = Faker::HeyArnold.quote
	us = rand(1...7)
	Playlist.create([{name: na, description: des, private: 'f',
							  user_id: us }])
end

########################################################################

playlist_songs = PlaylistSong.create([{playlist_id: '1', song_id: '1'}])

playlist_songs = PlaylistSong.create([{playlist_id: '1', song_id: '2'}])

playlist_songs = PlaylistSong.create([{playlist_id: '1', song_id: '3'}])

playlist_songs = PlaylistSong.create([{playlist_id: '1', song_id: '5'}])

playlist_songs = PlaylistSong.create([{playlist_id: '2', song_id: '4'}])

playlist_songs = PlaylistSong.create([{playlist_id: '2', song_id: '2'}])

##########################################################################

for i in 1...20
	us = rand(1...7)
	sid = rand(1...7)
	ra = rand(1...10)
	SongRating.create([{user_id: us, song_id: sid , rate: ra}])
end


# Usuarios siguen playlists
for i in 1...28
	pid = rand(1...10)
	UserFollowPlaylist.create([{user_id: i, playlist_id: pid}])
end

# Ponerle canciones a las playlists
for i in 1...30
	pid = rand(1...10)
	sid = rand(1...50)
	PlaylistSong.create([{playlist_id: pid, song_id: sid }])
end


# Usuario sigue a usuario
for i in 1...28
	num = rand(1...28)
	if num != i
		user_follow = Relationship.create([{followed_id: num, follower_id: i}])
	end
end
	
# 

# playlist created at
pl_all = Playlist.all
pl_all.each do |playls|
	puts 'AQQQQQQQQQUIIIIIIIIIIIIIIIIIIIIIIIIIIII'
	playls.created_at = "2017-11-26 00:00:00"
	playls.save
end

# album created at
# song created at
# music_group