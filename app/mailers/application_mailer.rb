class ApplicationMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  default from: 'hello@kitsu.io'
  layout 'mailer'
end
