module CurrentUserHelper
  def token_for(user, scopes = [])
    Doorkeeper::AccessToken.new(
      resource_owner: user,
      scopes: scopes.join(' ')
    )
  end

  def sign_in(user, scopes = [:all])
    token = token_for(user, scopes)
    @controller.send(:define_singleton_method, :current_user) { token }
  end
end

RSpec.configure do |config|
  config.include CurrentUserHelper
end
