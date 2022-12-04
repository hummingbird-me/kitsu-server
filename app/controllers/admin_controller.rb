class AdminController < ActionController::Base
  before_action :redirect_to_session
  include Pundit::Authorization
  protect_from_forgery with: :null_session

  rescue_from ActionController::InvalidAuthenticityToken do
    render plain: 'Token expired/invalid', status: 403
  end

  rescue_from Pundit::NotAuthorizedError do
    render plain: 'Not authorized', status: 403
  end

  def pundit_user
    @pundit_user ||= Doorkeeper::AccessToken.by_token('ac4baed8f0022af7851e327cfb3ab15a9517c78b71b5365368bd25ea96b2d677')
  end

  def current_user
    @current_user ||= User.find(pundit_user[:resource_owner_id]) if pundit_user
  end

  def redirect_to_session
  #  redirect_to '/api/sessions/new' unless session[:token]
  end
end
