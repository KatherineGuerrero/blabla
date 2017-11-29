class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
    @all_albums = Album.all
    @users = User.all
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @album = @song.album
    @creator = @song.user
    @band = @album.music_group

    if @song.ratings.length > 0

        if 4 > @song.get_rating and @song.get_rating >= 0

            @color = "#e20707"

        elsif 7 > @song.get_rating and @song.get_rating >= 4

            @color = "#e28e07"

        else

            @color = "#2aa01e"

        end

    else
        @color = "#2c3e50"
    end
  end

  # GET /songs/new
  def new
    if (user_signed_in? and current_user.role_id != 2 and @song.user_id != current_user.id) or !user_signed_in?
      redirect_to "/songs", notice: 'You are not allowed to create a song.'
    else
      @song = Song.new
    end
  end

  # GET /songs/1/edit
  def edit
    @user = @song.user
    if (user_signed_in? and current_user.role_id <= @user.role_id and @user.id != current_user.id) or !user_signed_in?
        redirect_to "/songs", notice: 'You are not allowed to edit that song.'
    else
      if current_user.role_id == 2
        # Si es admin tiene acceso a todo
        @albums = Album.all
      else
        # AQUI LE PASO SOLO LOS QUE EL USUARIO CREÓ #
        @albums = current_user.albums.all
        # # #
      end
    end
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = current_user.songs.build(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to "/users/upload_center", notice: 'Song was successfully created.' }
        # format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        @music_group = MusicGroup.new
        @album = Album.new
        format.html { render "/users/upload_center", :locals => { :song => @song }}
        # format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name, :file_url, :album_id, :user_id)
    end
end
