module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?
    before_action :require_authentication
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def signed_in?
    current_user.present?
  end

  def require_authentication
    unless signed_in?
      store_location
      redirect_to sign_in_path, alert: "Please sign in to continue."
    end
  end

  def skip_authentication
    # Override in controllers that don't require auth
  end

  def sign_in(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def sign_out
    session.delete(:user_id)
    @current_user = nil
  end

  def store_location
    session[:return_to] = request.fullpath if request.get?
  end

  def stored_location_or(default)
    session.delete(:return_to) || default
  end
end
