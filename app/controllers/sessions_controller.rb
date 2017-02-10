class SessionsController < ActionController::Base

  def index
  end

  def create
    session[:token] = params[:token]
    head :ok
  end
end
