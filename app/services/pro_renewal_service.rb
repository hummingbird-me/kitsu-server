# Manages the renewal of pro for a user, maintaining streak information, etc.
class ProRenewalService
  # How long after expiration does the user have to renew their sub for the streak to be maintained
  STREAK_GRACE_PERIOD = 1.day

  attr_reader :user

  # @param user [User] the user whose subscription we want to manage
  def initialize(user)
    @user = user
  end

  # Extend a user's pro for a period
  # @param start_date [DateTime] the datetime marking the start of this billing cycle
  # @param end_date [DateTime] the datetime marking the end of this billing cycle
  def renew_for(start_date, end_date)
    if user.pro_expires_at.nil? || (start_date - user.pro_expires_at) > STREAK_GRACE_PERIOD
      # Reset the pro streak if they are out of the grace period
      user.pro_started_at = start_date
    end
    user.pro_expires_at = end_date
    user.save!
  end
end
