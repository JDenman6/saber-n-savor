module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Create a persistant session for a user.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Retrieves the user in the current session if any.
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      raise #something
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authentic?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Check for current_user.
  def logged_in?
    !current_user.nil?
  end

  # Break a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Log out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
