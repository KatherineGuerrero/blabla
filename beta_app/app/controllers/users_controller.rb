class UsersController < ApplicationController
  # Ruby class with inheritance
  before_action :set_user, only: [:show, :edit, :update, :destroy, :change_password]
  before_action :authenticate_user!, except: [:show]

  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # Now you can access user's private data, create playlists and much more

    # # Access private data
    # spotify_user.country #=> "US"
    # spotify_user.email   #=> "example@email.com"

    # # Create playlist in user's Spotify account
    # playlist = spotify_user.create_playlist!('my-awesome-playlist')

    # # Add tracks to a playlist in user's Spotify account
    # tracks = RSpotify::Track.search('Know')
    # playlist.add_tracks!(tracks)
    # playlist.tracks.first.name #=> "Somebody That I Used To Know"

    # # Access and modify user's music library
    # spotify_user.save_tracks!(tracks)
    # spotify_user.saved_tracks.size #=> 20
    # spotify_user.remove_tracks!(tracks)

    # albums = RSpotify::Album.search('launeddas')
    # spotify_user.save_albums!(albums)
    # spotify_user.saved_albums.size #=> 10
    # spotify_user.remove_albums!(albums)

    # # Use Spotify Follow features
    # spotify_user.follow(playlist)
    # spotify_user.follows?(artists)
    # spotify_user.unfollow(users)

    # # Get user's top played artists and tracks
    # spotify_user.top_artists #=> (Artist array)
    # spotify_user.top_tracks(time_range: 'short_term') #=> (Track array)

    # Check doc for more

    redirect_to "/posts/news_feed"

  end

  def upload_center
    if !user_signed_in?
      redirect_to "/users/sign_in", notice: 'Sign in to get access to the Upload Center'
    else
      @music_group = current_user.music_groups.build
      @album = Album.new
      @song = Song.new
      @users = User.all
      if current_user.role_id == 2
        # Si es admin tiene acceso a todo
        @music_groups = MusicGroup.all
        @albums = Album.all
        # # #
      else
        # AQUI LE PASO SOLO LOS QUE EL USUARIO CREÓ #
        @music_groups = current_user.music_groups.all
        @albums = current_user.albums.all
        # # #
      end
    end
  end

  # GET /users
  # GET /users.json
  # def index
  #   @users = User.all
  # end

  # GET /users/1
  # GET /users/1.json
  def show
    # debugger
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
      if (user_signed_in? and current_user.role_id <= @user.role_id and @user.id != current_user.id) or !user_signed_in?
          redirect_to root_path, notice: 'You are not allowed to edit that user.'
      end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to '/static_pages/home', notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_password
  end

  def password_confirm_and_set
    @user = current_user
    respond_to do |format|
      if @user.update_with_password(user_params)
          bypass_sign_in(@user)
          format.html { redirect_to user_path, notice: 'Password changed successfully' }
      else
        if user_params[:password] != user_params[:password_confirmation]
            format.html { redirect_to change_password_user_path, notice: "Passwords don't match" }
        elsif user_params[:password].length < User.password_length.min
            format.html { redirect_to change_password_user_path, notice: 'Password is too short' }
        elsif !@user.valid_password?(user_params[:current_password])
            format.html { redirect_to change_password_user_path, notice: 'Current password is incorrect' }
        else
            format.html { redirect_to change_password_user_path, notice: 'Could not change password' }
        end
      end
    end
  end

  def follow_playlist
    @user = current_user
    @playlist_id = params[:playlist][:playlist_id]
    @notice = ""
    if @user.owns_playlist(@playlist_id)

        @destination = playlists_url
        @notice = 'Could not follow owned playlist'

    elsif @user.follows_playlist(@playlist_id)

        @destination = playlists_url
        @notice = 'Already following playlist'

    else

        @user_follow_playlist = UserFollowPlaylist.new
        @user_follow_playlist.user_id = @user.id
        @user_follow_playlist.playlist_id = @playlist_id

    end

    respond_to do |format|
      if @notice == ""
          if @user_follow_playlist.save
            @destination = playlist_path
            @notice = 'User follow playlist was successfully updated.'
          else
            format.html { render :edit }
          end
      end
      format.html { redirect_to @destination, notice: @notice }
    end

  end

  def following
    @user = User.find(params[:id])
    @users = @user.followed_users

    #debugger

    render 'show_follow'

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :profile_picture)
    end
end
