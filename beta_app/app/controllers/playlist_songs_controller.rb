class PlaylistSongsController < ApplicationController
  before_action :set_playlist_song, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :index]

  # GET /playlist_songs
  # GET /playlist_songs.json
  def index
    @playlist_songs = PlaylistSong.all
  end

  # GET /playlist_songs/1
  # GET /playlist_songs/1.json
  # def show
  # end

  # GET /playlist_songs/new
  def new
    @playlist_song = PlaylistSong.new
    @user = current_user
    if params[:from] == 'song'
      @song = Song.find(params[:song_id])
    end
  end

  # # GET /playlist_songs/1/edit
  # def edit
  # end

  # POST /playlist_songs
  # POST /playlist_songs.json
  def create
    @song = Song.find(params[:playlist_song][:song_id])
    @playlist = Playlist.find(params[:playlist_song][:playlist_id])
    @user = current_user
    @notice = ""

    if @playlist.has_song(@song)
        @notice = "Song already added to playlist"
    else
        @playlist_song = PlaylistSong.new(playlist_song_params)
        @playlist_song.playlist_id = @playlist.id
        @playlist_song.track_number = @playlist.songs.count + 1
        @playlist_song.song_id = @song.id
    end


    respond_to do |format|
      if @notice == ""
        if @playlist_song.save
            @notice = "Succesfully added to playlist"
        else
          format.html { render :new }
        end
      end
      format.html { redirect_to songs_url, notice: @notice }
    end
  end

  # PATCH/PUT /playlist_songs/1
  # PATCH/PUT /playlist_songs/1.json
  def update
    respond_to do |format|
      if @playlist_song.update(playlist_song_params)
        format.html { redirect_to @playlist_song, notice: 'Playlist song was successfully updated.' }
        format.json { render :show, status: :ok, location: @playlist_song }
      else
        format.html { render :edit }
        format.json { render json: @playlist_song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlist_songs/1
  # DELETE /playlist_songs/1.json
  def destroy
    @playlist_song.destroy
    respond_to do |format|
      format.html { redirect_to playlist_songs_url, notice: 'Playlist song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist_song
      @playlist_song = PlaylistSong.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_song_params
      params.require(:playlist_song).permit(:playlist_id, :song_id)
    end
end
