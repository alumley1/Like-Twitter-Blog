class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  validate :follow_self?
  validate :friend_exists?

  scope :paginate, lambda {|max| where(:id => (Friendship.first.id...max))}
  scope :lastest, order("created_at DESC")
  scope :newest, order("created_at ASC")

  def friend_exists?
    (errors[:base] << I18n.t("friendship.exist")) if Friendship.where(:user_id => user_id, :friend_id => friend_id).exists?
  end
  def follow_self?
    (errors[:base] << I18n.t("friendship.self")) if user_id == friend_id
  end
end
