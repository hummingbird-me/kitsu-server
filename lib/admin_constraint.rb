class AdminConstraint
  def self.matches?(request)
    return false unless request.session[:token]
    token = Doorkeeper::AccessToken.by_token(request.session[:token])
    user = User.find(token[:resource_owner_id])
    user && user.roles.where(name: 'admin').count > 0
  end
end
