class AdminController < ActionController::Base
  helper AdminHelper
  protect_from_forgery with: :null_session
  def handle_unverified_request
    # super # call the default behaviour, including Devise override
    # authenticate_user!
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    render text: 'Token expired/invalid', status: 498
  end
end
