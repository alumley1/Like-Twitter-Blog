class Tweet < ActiveRecord::Base
  belongs_to :user
  validates :content, :length => {:maximum => 140}
  validates_presence_of :content

  scope :paginate, lambda {|max| where(:id => (Tweet.first.id...max))}
  scope :get_new, lambda {|max| where(['id BETWEEN (?) AND (?) AND id NOT IN (?)', max, Tweet.last.id, max])}
  scope :lastest, order("created_at DESC")
  scope :newest, order("created_at ASC")

  def self.feed(user)
    friends = user.friendships.map(&:friend_id)
    Tweet.includes(:user).where(:user_id => [user.id, friends]).order("created_at DESC")
  end

  def self.get_tweets(user)
    Tweet.includes(:user).where(:user_id => user).order("created_at DESC")
  end

  def self.feedline(user)
    friends = user.friendships.map(&:friend_id)
    Tweet.includes(:user).where(:user_id => [user.id, friends])
  end

  def self.userline(user)
    Tweet.includes(:user).where(:user_id => user.id)
  end

  def get_last_tweets(integer)
    order("id DESC").limit(integer)
  end
end
