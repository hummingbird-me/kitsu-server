class ApplicationMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  default from: 'Kitsu <help@kitsu.io>'
  layout 'mailer'
end
