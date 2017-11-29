class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :index, :public_playlists]
  before_action :require_permission, only: [:edit, :update, :destroy]
  before_action :increment_view_count, only: [:show]


  # GET /playlists
  # GET /playlists.json
  def index
    @playlists = Playlist.all
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
  end

  # GET /playlists/new
  def new
    @playlist = current_user.playlists.build
  end

  # GET /playlists/1/edit
  def edit
      @user = @playlist.user
      if (user_signed_in? and current_user.role_id <= @user.role_id and @user.id != current_user.id) or !user_signed_in?
          redirect_to static_pages_home_path, notice: 'You are not allowed to edit that playlist.'
      end
  end

  # POST /playlists
  # POST /playlists.json
  def create
    @user = current_user
    @playlist = @user.playlists.build(playlist_params)

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to @playlist, notice: 'Playlist was successfully created.' }
        format.json { render :show, status: :created, location: @playlist }
      else
        format.html { render :new }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1
  # PATCH/PUT /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url, notice: 'Playlist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_index
    @playlist = Playlist.find(params[:playlist][:playlist_id])
    @playlist_song_1 = @playlist.playlist_songs.where("track_number = #{params[:playlist][:track_number]}").first
    @playlist_song_2 = @playlist.playlist_songs.where("track_number = #{params[:change_to]}").first

    @playlist_song_1.track_number = params[:change_to]
    @playlist_song_2.track_number = params[:playlist][:track_number]

    respond_to do |format|
      if @playlist_song_1.save && @playlist_song_2.save
        format.html { redirect_to edit_playlist_path, notice: 'Playlist was successfully updated.' }
      else
        format.html { render :edit }
      end
    end

  end

  def delete_song
    @playlist = Playlist.find(params[:playlist][:playlist_id])
    @playlist_song = @playlist.playlist_songs.where("track_number = #{params[:playlist][:track_number]}").first


    @playlist.playlist_songs.destroy(@playlist_song.id)

    @flag = true

    @i = 1
    for p_song in @playlist.playlist_songs
      puts p_song.track_number
      p_song.track_number = @i
      if !p_song.save
        @flag = false
      end
      @i += 1
    end

    respond_to do |format|
      if @flag
        format.html { redirect_to edit_playlist_path, notice: 'Playlist was successfully updated.' }
      else
        format.html { render :edit }
      end
    end

  end


  def public_playlists
      @public_playlists = Playlist.all.select{|a| !a[:private]}
      @most_viewed = @public_playlists.sort_by{|a| a[:view_count]}.reverse![0, 5]
      @most_recent = @public_playlists.sort_by{|a| a[:created_at]}.reverse![0, 5]
      @other = ["p1", "p2", "p3", "p4", "p5"]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:name, :description, :private)
    end

    #Only edit own playlists
    def require_permission
      if current_user != Playlist.find(params[:id]).user
        redirect_to playlists_url, notice: 'You are not allowed to edit this playlist'
      end
    end

    def increment_view_count
        @playlist.increment!(:view_count)
    end

end
