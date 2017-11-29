class MusicGroupsController < ApplicationController
  before_action :set_music_group, only: [:show, :edit, :update, :destroy]

  # GET /music_groups
  # GET /music_groups.json
  def index
    @music_groups = MusicGroup.all
    @users = User.all
  end

  # GET /music_groups/1
  # GET /music_groups/1.json
  def show
    @creator = @music_group.user
    @users = User.all
    @albums = @music_group.albums
  end

  # GET /music_groups/new
  def new
    @user = @music_group.user
    if (user_signed_in? and current_user.role_id <= @user.role_id and @user.id != current_user.id) or !user_signed_in?
      redirect_to "/music_groups", notice: 'You are not allowed to create a music group.'
    else
      @music_group = current_user.music_groups.build
    end
  end

  # GET /music_groups/1/edit
  def edit
    if (user_signed_in? and current_user.role_id != 2 and @music_group.user_id != current_user.id) or !user_signed_in?
        redirect_to "/music_groups", notice: 'You are not allowed to edit that music group.'
    end
  end

  # POST /music_groups
  # POST /music_groups.json
  def create
    # @music_group = MusicGroup.new(music_group_params)
    @music_group =  current_user.music_groups.build(music_group_params)
    respond_to do |format|
      if @music_group.save
        User.all.each do |user|
          RecommendationArtistMailer.recommendation_artist_email(user, @music_group).deliver_later
        end

        format.html { redirect_to "/users/upload_center", notice: 'Music group was successfully created.' }
        # format.html { redirect_to @music_group, notice: 'Music group was successfully created.' }
        format.json { render :show, status: :created, location: @music_group }
      else
        @song = Song.new
        @album = Album.new
        format.html { render "/users/upload_center", :locals => { :music_group => @music_group }}
        # format.html { render :new }
        format.json { render json: @music_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /music_groups/1
  # PATCH/PUT /music_groups/1.json
  def update
    respond_to do |format|
      if @music_group.update(music_group_params)
        format.html { redirect_to @music_group, notice: 'Music group was successfully updated.' }
        format.json { render :show, status: :ok, location: @music_group }
      else
        format.html { render :edit }
        format.json { render json: @music_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /music_groups/1
  # DELETE /music_groups/1.json
  def destroy
    @music_group.destroy
    respond_to do |format|
      format.html { redirect_to music_groups_url, notice: 'Music group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_music_group
      @music_group = MusicGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def music_group_params
      params.require(:music_group).permit(:name, :user_id, :bio, :profile_picture)
    end
end
