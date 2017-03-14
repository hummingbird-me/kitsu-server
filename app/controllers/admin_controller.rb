class AdminController < ActionController::Base
  before_action :redirect_to_session
  include Pundit
  include Doorkeeper
  include DoorkeeperHelpers
  helper AdminHelper
  protect_from_forgery with: :null_session

  rescue_from ActionController::InvalidAuthenticityToken do
    render text: 'Token expired/invalid', status: 403
  end

  def pundit_user
    Doorkeeper::AccessToken.by_token(session[:token])
  end

  def current_user
    User.find(pundit_user[:resource_owner_id])
  end

  def redirect_to_session
    redirect_to '/api/sessions/new' unless session[:token]
  end
end
