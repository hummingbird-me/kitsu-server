class UserMailer < ApplicationMailer
  def confirmation(user)
    @token = token_for(user, :email_confirm, expires_in: 7.days)
    @confirm_link = client_url_for("/confirm-email?token=#{@token.token}")
    mail to: user.email, subject: 'Welcome to Kitsu'
  end

  def password_reset(user)
    @token = token_for(user, :email_password_reset, expires_in: 6.hours)
    @reset_link = client_url_for("/password-reset?token=#{@token.token}")
    mail to: user.email, subject: 'Reset your Kitsu password'
  end

  private

  def token_for(user, scopes, expires_in:)
    scopes = scopes.join(' ') if scopes.is_a?(Array)
    Doorkeeper::AccessToken.create(resource_owner: user, refresh_token: nil,
                                   expires_in: expires_in, scopes: scopes.to_s)
  end

  def client_url_for(path)
    "#{root_url}#{path}".gsub(%r{([^:])/+}, '\1/')
  end
end
