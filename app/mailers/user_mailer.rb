class UserMailer < ApplicationMailer
  def confirmation(user)
    @user = user
    @token = token_for(user, :email_confirm, expires_in: 7.days)
    @confirm_link = client_url_for("/confirm-email?token=#{@token.token}")
    mail to: user.email, subject: 'Just one more step to get started on Kitsu'
  end

  def onboarding_follow_users(user)
    mail to: user.email,
         subject: "#{user.name}, want to get the most out of Kitsu?"
  end

  def reengagement(user, days_absent)
    subject_days_hash = {
      0 => 'Hey, it\'s been a while!',
      9 => 'Is everything okay?',
      18 => 'We haven\'t seen you in a while',
      28 => 'We feel lost without you...'
    }
    return unless subject_days_hash.key? days_absent
    @token = token_for(user, :email_confirm, expires_in: 7.days)
    @rengagement_link = client_url_for("/?token=#{@token.token}")
    mail to: user.email, subject: subject_days_hash[days_absent]
  end

  def notification(user, notification_kind, related_users, meta = {})
    return if related_users.empty?

    subject_user_stub = ''
    if related_users.length > 3
      subject_user_stub = "#{related_users.first.name},"\
        " #{related_users.second.name} and"\
        " #{related_users.length - 2}  others"
    elsif related_users.length == 2
      subject_user_stub = "#{related_users.first.name},"\
        " and #{related_users.second.name}"
    elsif related_users.length == 1
      subject_user_stub = related_users.first.name.to_s
    end

    @notification_kind = notification_kind

    subject_kind_hash = {
      1 => "#{subject_user_stub} liked your post on Kitsu",
      2 => "#{subject_user_stub} liked your post",
      3 => "#{subject_user_stub} replied to your post",
      4 => "#{subject_user_stub} mentioned you on Kitsu",
      5 => "#{subject_user_stub} followed you on Kitsu",
      6 => "#{subject_user_stub} posted on your profile",
      7 => "#{subject_user_stub} upvoted your Reaction"
    }

    @highligted_object = {
      1 => "View Post",
      2 => "View Post",
      3 => related_users.length > 1? "View Replies": "View Reply",
      4 => "View Post/Comment",
      5 => "View User",
      6 => "View Post",
      7 => "View Reaction"
    }

    @highligted_object_link = {
      1 => "View Post",
      2 => "View Post",
      3 => related_users.length > 1? "View Replies": "View Reply",
      4 => "View Post/Comment",
      5 => "View User",
      6 => "View Post",
      7 => "View Reaction"
    }

    @highligted_object_link_text = {
      1 => "View Post",
      2 => "View Post",
      3 => related_users.length > 1? "View Replies": "View Reply",
      4 => "View Post/Comment",
      5 => "View User",
      6 => "View Post",
      7 => "View Reaction"
    }


    return unless subject_kind_hash.key? notification_kind
    @subject = subject_kind_hash[notification_kind]
    mail to: user.email, subject: @subject
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
    "https://kitsu.io/#{path}".gsub(%r{([^:])/+}, '\1/')
  end
end
