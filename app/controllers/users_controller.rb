class UsersController < ApplicationController
  before_filter :unless_signed_in?, :only => [:index]
  def index
    @user = current_user
    @tweet = Tweet.new
    if user_signed_in?
      @tweets = @user.timeline(true).lastest.limit(10)
    end
    respond_to do |format|
      format.html
      format.json { render json: @tweets }
    end
  end

  def get
    @user = User.find(params[:id])
    max = params[:max_id].to_i
    limit = params[:limit].to_i
    if params[:feed] == "following"
      @users = @user.friendships.includes(:user).paginate(max).limit(limit).order("created_at DESC")
    elsif params[:feed] == "followers"
      @users = @user.inverse_friendships.includes(:user).paginate(max).limit(limit).order("created_at DESC")
    end
    (pagination = true) if @users.length <= 0
    respond_to do |format|
      unless pagination
        if params[:feed] == "following"
          format.html { render :partial => "friendships/following", :collection => @users }
        elsif params[:feed] == "followers"
          format.html { render :partial => "friendships/followers", :collection => @users }
        end
       else
        format.html {render :text => '<script>pagination = false;</script>'}
      end
      format.json { render json: @users}
    end
  end

  def following
    @user = User.find(params[:id])
    @following = @user.friendships.includes(:user).lastest
    respond_to do |format|
      format.html
      format.json { render json: @following }
    end
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.inverse_friendships.includes(:user).lastest
    respond_to do |format|
      format.html
      format.json { render json: @followers }
    end
  end

  def show
    @user = User.find(params[:id])
    @tweets = @user.timeline(false).lastest.limit(10)
    respond_to do |format|
      format.html
    end
  end

  private
  def unless_signed_in?
    redirect_to new_user_session_path unless user_signed_in?
  end
end
