class ApplicationMailer < ActionMailer::Base
  SMTP_SOFT_BOUNCES = [
    Errno::EINVAL,
    Errno::ECONNRESET,
    Errno::ECONNREFUSED,
    EOFError,
    Net::ProtocolError,
    SocketError,
    IOError,
    TimeoutError,
    Postmark::HttpClientError,
    Postmark::InternalServerError,
    Postmark::TimeoutError
  ].freeze
  SMTP_HARD_BOUNCES = [
    Postmark::InactiveRecipientError,
    Net::SMTPFatalError,
    Net::SMTPSyntaxError
  ].freeze

  include Rails.application.routes.url_helpers
  default from: 'Kitsu <help@kitsu.io>'
  layout 'mailer'

  rescue_from(*SMTP_HARD_BOUNCES) do
    raise MailSendError::HardBounce
  end

  rescue_from(*SMTP_SOFT_BOUNCES) do
    raise MailSendError::SoftBounce
  end
end
