class UserCommentsController < ApplicationController
skip_before_action :verify_authenticity_token  
  def create

    # debugger
    @user = User.find(params[:user_comment]["mentioned_id"])
    @comment = current_user.writed_comments.build()
    @comment.comment = params[:user_comment]["comment"]
    @comment.mentioned_id = @user.id

    # debugger
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @user, notice: 'comment was successfully made' }
        format.json { render :show, status: :created, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end


  end

end
