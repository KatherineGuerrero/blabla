# require 'rspotify'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  def news_feed
    res_spotify = RSpotify::Album.new_releases(country: 'CL')
    @spotify_releases = []
    res_spotify.each do |album|
      details = (album.name) + ' - ' + (album.artists.first.name)
      @spotify_releases.push(details)
    end
    # @artists = RS7potify::Artist.search("Jonas Brothers").first
    @posts = (Post.all).sort_by do |post|
      post[:created_at]
    end
    @posts = @posts.reverse
    @users = User.all
    if @post.nil?
      @post = Post.new
    end
  end

  def get_color
      colors = ["#2d3f51", "#3598da", "#18bc9b", "#f39b12"]
      return colors[rand(colors.length)]
  end

  helper_method :get_color

  # GET /posts/1
  # GET /posts/1.json
  def show
    @users = User.all
  end

  # GET /posts/new
  def new
    if (user_signed_in? and current_user.role_id != 2 and @post.user_id != current_user.id) or !user_signed_in?
        redirect_to "/posts/news_feed", notice: 'You are not allowed to create a post.'
    else
      @post = current_user.posts.build
    end
  end

  # GET /posts/1/edit
  def edit
    if (user_signed_in? and current_user.role_id != 2 and @post.user_id != current_user.id) or !user_signed_in?
        redirect_to "/posts/news_feed", notice: 'You are not allowed to edit that post.'
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post =  current_user.posts.build(post_params)
    @posts = (Post.all).sort_by do |post|
      post[:created_at]
    end
    @posts = @posts.reverse
    @users = User.all

    respond_to do |format|
      if @post.save
        # Redirecciono el Submit del form <3
        format.html { redirect_to "/posts/news_feed", notice: 'Post was successfully created.' }
        # ORIGINAL: format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        # Renderea en news_feed y pasa los errores
        format.html { render "/posts/news_feed", :locals => { :post => @post, :posts => @posts, :users => @users }}
        # ORIGINAL: format.html { render :new}
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @posts = (Post.all).sort_by do |post|
      post[:created_at]
    end
    @posts = @posts.reverse
    @users = User.all
    respond_to do |format|
      if @post.update(post_params)
        @edited_post_id = @post.id
        @post = Post.new
        @notice = 'Post was successfully updated.'
        format.html { render "/posts/news_feed", :locals => { :edited_post_id => @edited_post_id, :posts => @posts,
                      :users => @users}}
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to "/posts/news_feed", notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :user_id)
    end
end
