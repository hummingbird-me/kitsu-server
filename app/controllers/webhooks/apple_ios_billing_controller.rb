module Webhooks
  class AppleIosBillingController < ApplicationController
    include CustomControllerHelpers

    SECRET = AppleReceiptService::SECRET

    def notify
      AppleReceiptService.new(params[:latest_receipt]).call
      head :no_content
    end

    private

    def check_secret
      unless ActiveSupport::SecurityUtils.secure_compare(SECRET, params[:password])
        render_jsonapi_error 400, 'Invalid Secret'
      end
    end
  end
end
