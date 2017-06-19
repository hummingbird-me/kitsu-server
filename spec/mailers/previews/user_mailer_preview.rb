class UserMailerPreview < ActionMailer::Preview
  def confirmation
    UserMailer.confirmation(User.first)
  end

  def onboarding_follow_users
    UserMailer.onboarding_follow_users(User.first)
  end

  def reengagement_never
    UserMailer.reengagement(User.first, 0)
  end

  def reengagement_nine
    UserMailer.reengagement(User.first, 9)
  end

  def reengagement_eighteen
    UserMailer.reengagement(User.first, 18)
  end

  def reengagement_twentyeight
    UserMailer.reengagement(User.first, 28)
  end

  def notification_first_like
    UserMailer.notification(User.first, 1, [User.second])
  end

  def notification_liked
    UserMailer.notification(User.first, 2, [User.second])
  end

  def notification_replied
    UserMailer.notification(User.first, 3, [User.second])
  end

  def notification_mentioned
    UserMailer.notification(User.first, 4, [User.second])
  end

  def notification_followed
    UserMailer.notification(User.first, 5, [User.second])
  end

  def notification_posted
    UserMailer.notification(User.first, 6, [User.second])
  end
end
