module SessionsHelper
  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def authenticate_user!
    redirect_to root_path unless logged_in?
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns the current logged-in user if any
  # User.find(id) raises an exception if there's no such id in the db
  # User.find_by(id: id) won't raise an exception intead it returns nil
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Return true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  def user_admin?
    if current_user
      current_user.admin?
    else
      false
    end
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # Get cart size
  def get_cart_size
    if session[:cart]
      @cart_size = session[:cart].size
    else
      @cart_size = 0
    end
  end

  # Get Address
  def get_address
    if session[:saddress].present?
      @saddress = session[:saddress][:faddress]
    else
      @saddress = ""
    end
  end
end

