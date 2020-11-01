class SessionsController < ActionController::Base
  def new
    @redirect_to = params[:after]
  end

  def create
    return render status: :forbidden, plain: 'Token missing' if params[:token].blank?
    token = Doorkeeper::AccessToken.by_token(params[:token])
    is_admin = token.resource_owner.permissions.any?
    return render status: :forbidden, plain: 'Not allowed' unless is_admin
    session[:token] = params[:token]
    render status: :ok, plain: 'Success'
  end

  def redirect
    redirect_to url_for(
      controller: 'sessions',
      action: 'new',
      params: { after: request.url }
    )
  end
end
