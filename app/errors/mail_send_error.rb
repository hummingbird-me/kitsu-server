class MailSendError < StandardError
  class SoftBounce < MailSendError; end
  class HardBounce < MailSendError; end
end
