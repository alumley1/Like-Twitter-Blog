module FriendshipsHelper

  def follow_link(friend)
    link_to "Follow", friendships_path(:friend_id => friend), :remote => true, :method => :post, :class => "btn-follow", "data-user-id" => friend
  end

  def unfollow_link(friend)
    link_to "Following", friendship_path(friend), :method => :delete, :remote => true, :class => "btn-unfollow", "data-user-id" => friend
  end

  def follow_button(user, friend)
    unless user == friend
      if Friendship.find_by_user_id_and_friend_id(user, friend).nil?
        follow_link(friend.id)
      else
        unfollow_link(friend.id)
      end
    end
  end
end
