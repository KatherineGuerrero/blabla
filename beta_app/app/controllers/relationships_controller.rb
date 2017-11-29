class RelationshipsController < ApplicationController

  def create
    #debugger
    @user = User.find(params[:user]["user_id"])
    current_user.follow_user(@user)

    respond_to do |format|
      format.html {redirect_to @user, notice: 'User was succesfully followed'}
    end
  end

  def delete
    #debugger
    @user = User.find(params[:user]["user_id"])
    current_user.unfollow_user(@user)

    respond_to do |format|
      format.html {redirect_to @user, notice: 'User was succesfully unfollowed'}
    end


  end


end
