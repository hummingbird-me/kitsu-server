class ApplicationMailer < ActionMailer::Base
  SMTP_SOFT_BOUNCES = [
    IOError,
    Net::SMTPAuthenticationError,
    Net::SMTPServerBusy,
    Net::SMTPUnknownError,
    TimeoutError
  ].freeze
  SMTP_HARD_BOUNCES = [Net::SMTPFatalError, Net::SMTPSyntaxError].freeze

  include Rails.application.routes.url_helpers
  default from: 'Kitsu <help@kitsu.io>'
  layout 'mailer'

  rescue_from(*SMTP_HARD_BOUNCES) do
    raise MailSendError::HardBounce, message.to
  end

  rescue_from(*SMTP_SOFT_BOUNCES) do
    raise MailSendError::SoftBounce, message.to
  end
end
