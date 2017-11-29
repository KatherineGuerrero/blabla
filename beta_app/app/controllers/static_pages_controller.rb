require 'set'

class StaticPagesController < ApplicationController
  before_action :set_options, only: [:advanced_search, :search_page]

  def home
      @music_groups = MusicGroup.all.sort_by{|a| a[:created_at]}.reverse![0,6] #6 more recent
      # TODO: paginate to see more, sort by popularity
      @rated_albums = Album.all.select{|a| a.ratings.length > 0}
      @albums = @rated_albums.sort_by{|a| a.get_rating}.reverse![0, 6] #6 with bigger ratings
      @rated_songs = Song.all.select{|a| a.ratings.length > 0}
      @songs = @rated_songs.sort_by{|a| a.get_rating}.reverse![0, 6] #6 with bigger ratings

      images =  [   "/assets/homepage_banner/turntable.jpg",
                    "/assets/homepage_banner/radio-city-music-hall.jpg",
                    "/assets/homepage_banner/electric.jpg",
                    "/assets/homepage_banner/violins.jpg"
                ]
      @banner_image = images[rand(images.size)]


  end


  def advanced_search

    kind = advanced_search_params["kind"]
    search = advanced_search_params["search"]

    @term = search
    @results = Hash.new



    if kind[0..1] == "gr"
        @results["Music Groups"] = group_filter(search, kind[3..-1]).to_set
    elsif kind[0..1] == "al"
        @results['Albums'] = album_filter(search, kind[3..-1]).to_set
    elsif kind[0..1] == "sg"
        @results['Songs'] = song_filter(search, kind[3..-1]).to_set
    elsif kind[0..1] == "pl"
        @results['Playlists'] = playlist_filter(search, kind[3..-1]).to_set
    end
    #debugger()



    respond_to do |format|
      format.html { render 'static_pages/search_page' }
    end
  end

  def help
  end

  def search_page
    @blank = true
    @term = search_params[:search].strip()
    if @term != ""
      @results = self.search(@term)
      @results.each do |key, value|
          if !value.empty?
            @blank = false
          end
      end
    end
  end

  def search(term)
      results = Hash.new
      results["Playlists"] = Playlist.where("name LIKE ?", "%#{term}%")
      results["Songs"] = Song.where("name LIKE ?", "%#{term}%")
      results["Albums"] = Album.where("name LIKE ?", "%#{term}%")
      results["Music Groups"] = MusicGroup.where("name LIKE ?", "%#{term}%")
      results["Users"] = User.where("name LIKE ?", "%#{term}%")
      return results
  end

  private

  def search_params
    params.permit(:search)
  end

  def advanced_search_params
    if  params.has_key? static_pages_search_page_url
      return params.require(static_pages_search_page_url).permit(:search, :kind)
    elsif params.has_key? static_pages_advanced_search_url
      return params.require(static_pages_advanced_search_url).permit(:search, :kind)
    else
      {"kind" => "-", "search" => "empty"}  
    end
  end

  def set_options
    @grouped_options = [
        ['Group',
         [['user','gr_user'],['album','gr_album'],
         ['song','gr_song'], ['name','gr_name']
         ]],
        ['Playlist',
         [['name','pl_name'],['description','pl_description'],
          ['user', 'pl_user'] ]],
        ['Album',
         [['group','al_group'],['rating','al_rating'],
          ['name','al_name'], ['song','al_song']]],
        ['Song',
        [['group', 'sg_group'],['album','sg_album'],
        ['rating','sg_rating'],['name', 'sg_name']]]
        ]
  end


  def group_filter(search, kind)
    if kind == "name"
      MusicGroup.where("name LIKE ?", "%#{search}%")

    elsif kind == "album"
      albums = Album.where("name LIKE ?", "%#{search}%")
      ret = []
      for album in albums
        ret << MusicGroup.find(album.music_group_id)
      end
      ret

    elsif kind == "song"
      songs = Song.where("name LIKE ?", "%#{search}%")
      ret = []
      for song in songs
        album = Album.find(song.album_id)
        ret << MusicGroup.find(album.music_group_id)
      end
      ret

    elsif kind == "user"
      users = User.where("name LIKE ?", "%#{search}%")
      ret = []
      for user in users
        mg = MusicGroup.find_by_user_id(user.id)
        if mg
          ret << mg
        end
      end
      ret
    end
  end

  def album_filter(search, kind)
    if kind == "name"
      Album.where("name LIKE ?", "%#{search}%")

    elsif kind == "rating"
      ret = []
      for album in Album.all
        a_rating =  album.get_rating.to_i
        search_rating = search.to_i
        if a_rating ==  search_rating
          ret << album
        end
      end
      ret

    elsif kind == "group"
        groups = MusicGroup.where("name LIKE ?", "%#{search}%")
        ret = []
        for group in groups
          albums = Album.where(music_group_id: group.id)
          if albums
              ret.concat albums
          end
        end
        ret

    elsif kind == "song"

        songs = Song.where("name LIKE ?", "%#{search}%")
        ret = []
        for song in songs
          ret.concat Album.where(id: song.album_id)
        end
        ret
    end
  end


  def song_filter(search, kind)
    if kind == "name"
      Song.where("name LIKE ?", "%#{search}%")

    elsif kind == "rating"
        ret = []
        for song in Song.all
          if song.get_rating.to_i == search.to_i
            ret << song
          end
        end
        ret

    elsif kind == "album"
      albums = Album.where("name LIKE ?", "%#{search}%")
      ret = []
      for album in albums
        ret.concat Song.where(album_id: album.id)
      end
      ret

    elsif kind == "group"
      groups = MusicGroup.where("name LIKE ?", "%#{search}%")
      ret = []
      for  group in groups
        for album in group.albums
          ret.concat Song.where(album_id: album.id)
        end
      end
      ret
    end
  end


  def playlist_filter(search, kind)
    if kind == "name"
      Playlist.where("name LIKE ?", "%#{search}%")

    elsif kind == "user"
      users = User.where("name LIKE ?", "%#{search}%")
      ret = []
      for user in users
        ret.concat Playlist.where(user_id: user.id)
      end
      ret

    elsif kind == "description"
      Playlist.where("description LIKE ?", "%#{search}%")
    end
  end


end
