module UsersHelper
  def you_are(user)
    (user_signed_in? && current_user == user) ? "You" : user.name
  end
end
