class AdminController < ActionController::Base
  include Pundit
  include DoorkeeperHelpers
  helper AdminHelper
  protect_from_forgery with: :null_session
  before_action :set_paper_trail_whodunnit
  def handle_unverified_request
    # super # call the default behaviour, including Devise override
    # authenticate_user!
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    render text: 'Token expired/invalid', status: 498
  end


  def current_user
    puts session[:token]
    session[:token]
  end
end
