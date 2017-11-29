class SongRatingsController < ApplicationController


  def update

    @song = Song.find(params[:song_rating][:song_id])
    @rating = @song.ratings.find_by_user_id(current_user.id)

    respond_to do |format|
      if @rating.update(song_rating_params)
        format.html { redirect_to @song, notice: 'Rating was succesfully added' }
        format.json { render :show, status: :ok, location: @rating }
      else
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @song = Song.find(params[:song_rating][:song_id])
    @rating = SongRating.new(song_rating_params)

    respond_to do |format|
      if @rating.save
        format.html { redirect_to @song, notice: 'Rating was successfully added' }
        format.json { render :show, status: :created, location: @rating }
      else
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def song_rating_params
    params.require(:song_rating).permit(:user_id, :song_id, :rate)
  end
end
