class ProfilePicturePickerController < ApplicationController
    protect_from_forgery prepend: true # TODO: check if this is safe
    before_action :authenticate_user!, only: [:choose_picture, :update_profile_picture]
    before_action :set_user, only: [:choose_picture, :update_profile_picture]
    before_action :grant_access, only: [:choose_picture, :update_profile_picture]

    def choose_picture
    end


    def update_profile_picture
        @file = params[:user][:profile_picture]
        File.open(@file.tempfile) do |f|
            @user.profile_picture = f
        end
        respond_to do |format|
          if @user.save!
              format.html { redirect_to user_path, notice: 'Profile picture succesfully uploaded.' }
          else
              format.html { redirect_to user_path, notice: 'Error, image was not uploaded.' }
          end
        end
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      def grant_access
          if @user.id != current_user.id
              redirect_back(fallback_location: user_path)
          end
      end

end
