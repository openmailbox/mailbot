class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    if !current_user
      redirect_to login_path
    elsif current_user.discord_identity&.token_expired?
      flash[:notice] = 'Your session has expired. Please sign in.'
      redirect_to logout_path
    end
  end
end
