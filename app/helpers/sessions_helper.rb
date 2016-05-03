module SessionsHelper

  # 'session' is an object Rails creates to track the state of a particular user.
  # There is one user id per session and one session per user id.
  def create_session(user)
    session[:user_id] = user.id
  end

  # Setting the user id to nil effectively destroys the session as it can no
  # longer be tracked.
  def destroy_session(user)
    session[:user_id] = nil
  end

  # Because our session only stores the user id, we need to retrieve the User
  # instance and all its properties.
  def current_user
    User.find_by(id: session[:user_id])
  end

  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
