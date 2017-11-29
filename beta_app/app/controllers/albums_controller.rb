class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all
    @users = User.all
    @musicgroups = MusicGroup.all
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @creator = @album.user
    @music_group = @album.music_group
    @songs = @album.songs

    if @album.ratings.length > 0

        if 4 > @album.get_rating and @album.get_rating >= 0

            @color = "#e20707"

        elsif 7 > @album.get_rating and @album.get_rating >= 4

            @color = "#e28e07"

        else

            @color = "#2aa01e"

        end

    else
        @color = "#2c3e50"
    end
  end

  # GET /albums/new
  def new
    if (user_signed_in? and current_user.role_id != 2 and @album.user_id != current_user.id) or !user_signed_in?
      redirect_to "/albums", notice: 'You are not allowed to create an album.'
    else
      @album = Album.new
      if current_user.role_id == 2
        # Si es admin tiene acceso a todo
        @music_groups = MusicGroup.all
      else
        # AQUI LE PASO SOLO LOS QUE EL USUARIO CREÓ #
        @music_groups = current_user.music_groups.all
        # # #
      end
    end
  end

  # GET /albums/1/edit
  def edit
    @user = @album.user
    if (user_signed_in? and current_user.role_id <= @user.role_id and @user.id != current_user.id) or !user_signed_in?
        redirect_to "/albums", notice: 'You are not allowed to edit that album.'
    else
      if current_user.role_id == 2
        # Si es admin tiene acceso a todo
        @music_groups = MusicGroup.all
      else
        # AQUI LE PASO SOLO LOS QUE EL USUARIO CREÓ #
        @music_groups = current_user.music_groups.all
        # # #
      end
    end
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = current_user.albums.build(album_params)

    respond_to do |format|
      if @album.save
        User.all.each do |user|
          RecommendationAlbumMailer.recommendation_album_email(user, @album).deliver_later
        end


        @music_group = current_user.music_groups.build
        @album = Album.new
        @song = Song.new
        # @users = User.all
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

        @notice = 'Album was successfully created.'
        format.html { render "/users/upload_center", :locals => { :music_group => @music_group,
                       :music_groups => @music_groups, :album => @album, :albums => @albums, :song => @song }}

        # format.html { redirect_to "/users/upload_center", notice: 'Album was successfully created.' }
        # format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        # Estos dos son para que las partes de song y music group
        # en el Upload Center puedan quedar disponibles
        @music_group = MusicGroup.new
        @song = Song.new
        format.html { render "/users/upload_center", :locals => { :album => @album }}
        # format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:name, :user_id, :music_group_id, :release_date, :cover)
    end
end
