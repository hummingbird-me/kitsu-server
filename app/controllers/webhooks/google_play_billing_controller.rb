module Webhooks
  class GooglePlayBillingController < ApplicationController
    include CustomControllerHelpers

    SECRET = ENV['GOOGLE_PLAY_BILLING_WEBHOOK_SECRET']

    def notify
      GooglePlayNotificationService.new(params).call
      head 204
    end

    private

    def check_secret
      unless ActiveSupport::SecurityUtils.secure_compare(SECRET, params[:secret])
        render_jsonapi_error 400, 'Invalid Secret'
      end
    end
  end
end
