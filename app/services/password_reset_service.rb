class PasswordResetService
  class EmailMissingError < StandardError; end
  class UserNotFoundError < StandardError; end

  def initialize(email)
    raise EmailMissingError if email.blank?
    @email = email
  end

  def send!
    raise UserNotFoundError unless user!
    UserMailer.password_reset(user!).deliver_later
  end

  def conflict_detector
    @conflict_detector ||= Zorro::UserConflictDetector.new(email: @email)
  end
  delegate :user!, to: :conflict_detector
end
