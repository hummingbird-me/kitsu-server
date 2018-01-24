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
    # TODO: stop hardcoding this and fix root_url
    # Also, this gsub collapses runs of more than one forward-slash (except in
    # the protocol)
    "#{client_url_base}/#{path}".gsub(%r{([^:])/+}, '\1/')
  end

  def client_url_base
    if Rails.env.production?
      'https://kitsu.io'
    elsif Rails.env.staging?
      'https://staging.kitsu.io'
    else
      'https://localhost'
    end
  end
end
