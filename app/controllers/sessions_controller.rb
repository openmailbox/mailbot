class SessionsController < ApplicationController
  def create
    head :ok
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] ||= 'Signed out.'
    redirect_to login_path
  end

  def new
  end
end
