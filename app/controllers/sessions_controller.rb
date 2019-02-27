class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :destroy]
  skip_before_action :verify_authenticity_token, only: :create

  def create
    auth_hash = request.env['omniauth.auth']
    user      = User.find_or_create_by_auth_hash(auth_hash)

    if user
      session[:user_id] = user.id
      flash[:notice] = "Signed in as #{user.id}"
      render plain: 'Logged in.'
    else
      flash[:notice] = 'Unable to sign in.'
      redirect_to login_path, status: :not_found
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] ||= 'Signed out'
    redirect_to login_path
  end

  def new
  end
end
