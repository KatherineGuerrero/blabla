class AlbumRatingsController < ApplicationController



  def create
    @rating = current_user.ratings.build()
    @user = current_user
    @album = Album.find(params[:album_rating]['album_id'])
    @rating.user_id = @user.id
    @rating.album_id = @album.id
    @rating.rate = params[:album_rating]['rate']

    respond_to do |format|
      if @rating.save
        format.html { redirect_to @album, notice: 'Rating was successfully added' }
        format.json { render :show, status: :created, location: @rating }
      else
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    @album = Album.find(params[:album_rating]['album_id'])
    @rating = @album.ratings.find_by_user_id(current_user.id)

    respond_to do |format|
      if @rating.update(params.require(:album_rating).permit(:user_id ,:album_id, :rate))
        format.html { redirect_to @album, notice: 'Rating was succesfully added' }
        format.json { render :show, status: :ok, location: @rating }
      else
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end


end
