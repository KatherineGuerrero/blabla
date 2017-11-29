#require 'date'

class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :require_permission, only: [:dashboard]

    def dashboard
        @songs = Song.all
        @users = User.all
        @albums = Album.all
        @bands = MusicGroup.all

        @songs_recent = Song.all.sort_by{ |a| a.created_at  }.reverse![0,4]

        @albums_recent = Album.all.sort_by{ |a| a[:created_at]  }.reverse![0,4]
        @bands_recent = MusicGroup.all.sort_by{ |a| a[:created_at]  }.reverse![0,4]
        @playlists_recent = Playlist.all.sort_by{ |a| a[:created_at]  }.reverse![0,4]


        gon.songs_recent = []
        @songs_recent.each do |item|
            new_entry = ["Song"]
            new_entry << item.name << item.user.name
            gon.songs_recent << new_entry
        end

        gon.albums_recent = []
        @albums_recent.each do |item|
            new_entry = ["Album"]
            new_entry << item.name << item.user.name
            gon.albums_recent << new_entry
        end

        gon.bands_recent = []
        @bands_recent.each do |item|
            new_entry = ["Band"]
            new_entry << item.name << item.user.name
            gon.bands_recent << new_entry
        end

        gon.playlists_recent = []
        @playlists_recent.each do |item|
            new_entry = ["Playlist"]
            new_entry << item.name << item.user.name
            gon.playlists_recent << new_entry
        end

        @popular_users = User.all.sort_by{|a| a.followers.length}.reverse![0,5]
        @popular_playlists = Playlist.all.sort_by{|a| a.followers.length}.reverse![0,5]

        gon.array_1_dates = get_week_dates()
        gon.array_1_songs = get_song_counts(gon.array_1_dates)
        gon.array_1_albums = get_album_counts(gon.array_1_dates)
        gon.array_1_bands = get_band_counts(gon.array_1_dates)
        gon.array_1_playlists = get_playlist_counts(gon.array_1_dates)

    end

    def get_week_dates()
        dates = []
        date = DateTime.now - 7
        songs = Song.all
        for i in 0..7
            dates << [date.year, date.month, date.day, 0, 0, 0]
            date = date.next_day
        end
        return dates
    end

    def get_song_counts(dates)
        values = []
        group = Song.group_by_day(:created_at, range: 7.days.ago.midnight..Time.now).count
        group.each do |value|
            values << value[1]
        end
        return values
    end

    def get_album_counts(dates)
        values = []
        group = Album.group_by_day(:created_at, range: 7.days.ago.midnight..Time.now).count
        group.each do |value|
            values << value[1]
        end
        return values
    end

    def get_band_counts(dates)
        values = []
        group = MusicGroup.group_by_day(:created_at, range: 7.days.ago.midnight..Time.now).count
        group.each do |value|
            values << value[1]
        end
        return values
    end

    def get_playlist_counts(dates)
        values = []
        group = Playlist.group_by_day(:created_at, range: 7.days.ago.midnight..Time.now).count
        group.each do |value|
            values << value[1]
        end
        return values
    end

    private

        def require_permission
            if current_user.role_id != 2
                redirect_to static_pages_home_path, notice: 'Dashboard is for administrators only'
            end
        end

end
