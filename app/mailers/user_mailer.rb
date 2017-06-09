class UserMailer < ApplicationMailer
  def confirmation(user)
    @token = token_for(user, :email_confirm, expires_in: 7.days)
    @confirm_link = client_url_for("/confirm-email?token=#{@token.token}")
    mail to: user.email, subject: 'Welcome to Kitsu'
  end

  def onboarding_welcome(user)
  end

  def onboarding_follow_users(user)
  end

  def reengagement(user, days_absent)
    subject_days_hash = {
      0: 'Hey, it\'s been a while!',
      9: 'Is everything okay?',
      18: 'We haven\'t seen you in a while',
      28: 'We feel lost without you...'
    }
    return unless subject_days_hash.key? days_absent
  end

  def notification(user)
    #only send if new ones from stream?
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
    "https://kitsu.io/#{path}".gsub(%r{([^:])/+}, '\1/')  end
end
