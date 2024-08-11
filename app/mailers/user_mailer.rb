class UserMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def confirmation(user)
    return nil if user.blank?
    @user = user
    @token = token_for(user, :email_confirm, expires_in: 7.days)
    @confirm_link = client_url_for("/confirm-email?token=#{@token.token}")
    mail to: user.email, subject: 'Activate your Account'
  end

  def password_reset(user)
    return nil if user.blank?
    @user = user
    @token = token_for(user, :email_password_reset, expires_in: 6.hours)
    @reset_link = client_url_for("/password-reset?token=#{@token.token}")
    mail to: user.email, subject: 'Reset your Password'
  end

  private

  def roadie_options
    super.merge(
      keep_uninlinable_css: true,
      url_options: Rails.application.config.action_mailer.default_url_options
    )
  end

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
      'https://kitsu.app'
    elsif Rails.env.staging?
      'https://staging.kitsu.app'
    else
      'https://localhost'
    end
  end
end
