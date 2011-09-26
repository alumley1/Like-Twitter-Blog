class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :avatar, :name, :email, :password, :password_confirmation, :remember_me
  has_many :tweets
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :friended, :through => :inverse_friendships, :source => :user
  validates_presence_of :name

  scope :paginate, lambda {|max| where(:id => (User.first.id...max))}
  scope :lastest, order("created_at DESC")
  scope :newest, order("created_at ASC")

  has_attached_file :avatar, :styles => {:small => "32x32#", :medium => "48x48#", :big => "128x128#"}

  def timeline(feedline = false)
    if feedline == true
      Tweet.feedline(self)
    else
      Tweet.userline(self)
    end
  end
end
