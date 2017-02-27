class SessionsController < ActionController::Base
  def new; end

  def create
    session[:token] = params[:token]
    head :ok
  end
end
