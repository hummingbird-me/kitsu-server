class SessionsController < ActionController::Base
  def new
    @redirect_to = local_path(params[:after])
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
      params: { after: request.fullpath }
    )
  end

  private

  # The login page hands this to window.location.replace, so it must never be
  # anything but a path on this site: no scheme (javascript:), no host (//evil).
  # URI.parse also rejects the backslashes and whitespace browsers normalise.
  def local_path(url)
    uri = URI.parse(url.to_s)
    path = [uri.path, uri.query].compact.join('?')
    path.match?(%r{\A/(?!/)}) ? path : '/api/admin'
  rescue URI::InvalidURIError
    '/api/admin'
  end
end
