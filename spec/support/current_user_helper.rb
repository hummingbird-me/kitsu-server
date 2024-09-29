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

  def with_current_user(user)
    Thread.current[:current_user] = user
    yield
  ensure
    Thread.current[:current_user] = nil
  end
end

RSpec.configure do |config|
  config.include CurrentUserHelper
end
