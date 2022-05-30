module Webhooks
  class GooglePlayBillingController < ApplicationController
    include CustomControllerHelpers

    SECRET = ENV.fetch('GOOGLE_PLAY_BILLING_WEBHOOK_SECRET', nil)

    def notify
      GooglePlayNotificationService.new(params).call
      head :no_content
    end

    private

    def check_secret
      unless ActiveSupport::SecurityUtils.secure_compare(SECRET, params[:secret])
        render_jsonapi_error 400, 'Invalid Secret'
      end
    end
  end
end
