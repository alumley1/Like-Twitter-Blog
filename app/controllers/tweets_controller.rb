class TweetsController < ApplicationController
  load_and_authorize_resource :only => [:create, :destroy]
  include TweetsHelper
  # GET /tweets/1
  # GET /tweets/1.json

  def get
    @user = User.find(params[:id])
    max = params[:max_id].to_i
    limit = params[:limit].to_i
    if params[:update] == "false"
      if params[:timeline] == "true"
        @tweets =  @user.timeline(true).paginate(max).lastest.limit(limit)
      else
        @tweets = @user.timeline(false).paginate(max).lastest.limit(limit)
      end
      (pagination = true) if @tweets.length <= 0
    else
      if params[:timeline] == "true"
        @tweets = @user.timeline(true).get_new(max).lastest
      else
        @tweets = @user.timeline(false).get_new(max).lastest
      end
    end
    respond_to do |format|
      unless pagination
        format.html { render @tweets }
      else
        format.html {render :text => '<script>pagination = false;</script>'}
      end
        format.json { render json: @tweets}
    end
  end

  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: user_tweet_path(@tweet) }
    end
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @user = current_user
    @tweet = @user.tweets.new(params[:tweet])
    respond_to do |format|
      if @tweet.save
        format.js
        format.html { redirect_to root_path, notice: 'Tweet was successfully created.' }
      else
        flash.keep[:error] = @tweet.errors.full_messages
        format.js
        format.html { redirect_to :back }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @user = User.find(params[:user_id])
    @tweet = @user.tweets.find(params[:id])
    @tweet.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
      format.json { head :ok }
    end
  end
end
