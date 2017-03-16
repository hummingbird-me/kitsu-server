class SessionsController < ActionController::Base
  def new; end

  def create
    return render status: 403, text: 'Token missing' if params[:token].blank?
    session[:token] = params[:token]
    render status: 200, text: 'Success!'
  end
end
