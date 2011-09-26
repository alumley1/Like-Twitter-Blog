class FriendshipsController < ApplicationController
  before_filter :unless_signed_in?, :only => [:create, :destroy]
  # POST /friendships
  # POST /friendships.json
  def create
    @friend = params[:friend_id].to_i
    @friendship = current_user.friendships.build(:friend_id => @friend)

    respond_to do |format|
      if @friendship.save
        format.js
        format.html { redirect_to root_path, notice: 'Friendship was successfully created.' }
      else
        flash.keep[:global_error] = @friendship.errors.full_messages
        format.html { redirect_to root_path, notice: "Can't add a friend" }
      end
    end
  end


  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @user = current_user
    @friend = params[:id]
    @friendship = Friendship.find_by_user_id_and_friend_id(@user, @friend)
    @friendship.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
      format.json { head :ok }
    end
  end

  private
  def unless_signed_in?
    redirect_to new_user_registration_path unless user_signed_in?
  end
end
