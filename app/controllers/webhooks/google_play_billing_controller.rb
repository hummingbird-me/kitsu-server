module Webhooks
  class GooglePlayBillingController < ApplicationController
    include CustomControllerHelpers

    SECRET = ENV['GOOGLE_PLAY_BILLING_WEBHOOK_SECRET']

    def notify
      GooglePlayNotificationService.new(params).call
      status 204
    end

    private

    def check_secret
      status 400 unless ActiveSupport::SecurityUtils.secure_compare(SECRET, params[:secret])
    end
  end
end
