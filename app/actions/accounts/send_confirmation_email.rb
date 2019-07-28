module Accounts
  class SendConfirmationEmail < Action
    parameter :user, load: User, required: true

    def call
      message = UserMailer.confirmation(user).deliver_now
      { message: message }
    rescue MailSendError::HardBounce
      user.update(email_status: :email_bounced)
    end
  end
end
