class FavoritedSongsController < ApplicationController
  def create
    #debugger
    @song = Song.find(params[:song]["song_id"])
    current_user.add_favorited_song(@song)

    respond_to do |format|
      format.html {redirect_to @song, notice: 'Song was succesfully favorited'}
    end
  end

  def delete
    # debugger
    @song = Song.find(params[:song]["song_id"])
    current_user.delete_favorited_song(@song)
    # debugger
    respond_to do |format|
      format.html {redirect_to @song, notice: 'Song was succesfully unfavorited'}
    end


  end



end
