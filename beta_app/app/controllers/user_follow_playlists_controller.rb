class UserFollowPlaylistsController < ApplicationController
  before_action :set_user_follow_playlist, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :index]

  # GET /user_follow_playlists
  # GET /user_follow_playlists.json
  def index
    @user_follow_playlists = UserFollowPlaylist.all
  end

  # GET /user_follow_playlists/1
  # GET /user_follow_playlists/1.json

  # def show
  # end

  # GET /user_follow_playlists/new
  def new
    @user_follow_playlist = UserFollowPlaylist.new
  end

  # GET /user_follow_playlists/1/edit
  # def edit
  # end

  # POST /user_follow_playlists
  # POST /user_follow_playlists.json
  def create
    @user_follow_playlist = UserFollowPlaylist.new(user_follow_playlist_params)

    @user = current_user

    @user_follow_playlist.user_id = @user.id
    @user_follow_playlist.playlist_id = params[:playlist][:playlist_id]

    respond_to do |format|
      if @user_follow_playlist.save
        format.html { redirect_to @user_follow_playlist, notice: 'User follow playlist was successfully created.' }
        format.json { render :show, status: :created, location: @user_follow_playlist }
      else
        format.html { render :new }
        format.json { render json: @user_follow_playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_follow_playlists/1
  # PATCH/PUT /user_follow_playlists/1.json
  def update
    respond_to do |format|
      if @user_follow_playlist.update(user_follow_playlist_params)
        format.html { redirect_to @user_follow_playlist, notice: 'User follow playlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_follow_playlist }
      else
        format.html { render :edit }
        format.json { render json: @user_follow_playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_follow_playlists/1
  # DELETE /user_follow_playlists/1.json
  def destroy
    @user_follow_playlist.destroy
    respond_to do |format|
      format.html { redirect_to user_follow_playlists_url, notice: 'User follow playlist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_follow_playlist
      @user_follow_playlist = UserFollowPlaylist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_follow_playlist_params
      params.require(:playlist).permit(:playlist_id)
    end
end
