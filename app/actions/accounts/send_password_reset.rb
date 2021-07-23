module Accounts
  class SendPasswordReset < Action
    parameter :email, required: true

    def call
      UserMailer.password_reset(user).deliver_later

      { email: email }
    end

    private

    def conflict_detector
      @conflict_detector ||= Zorro::UserConflictDetector.new(email: email)
    end

    def user
      @user ||= conflict_detector.user!
    end
  end
end
