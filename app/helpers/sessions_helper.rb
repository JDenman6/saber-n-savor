module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Retrieves the user in the current session if any.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Check for current_user.
  def logged_in?
    !current_user.nil?
  end
end
