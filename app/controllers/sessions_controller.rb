class SessionsController < ActionController::Base

  def index
  end

  def create
    session[:token] = params[:token]
    redirect_to "/api/admin"
  end
end
