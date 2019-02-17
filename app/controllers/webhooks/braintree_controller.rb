module Webhooks
  class BraintreeController < ApplicationController
    include CustomControllerHelpers

    def notify
      ProcessBraintreeWebhook.call(
        signature: params[:bt_signature],
        payload: params[:bt_payload]
      )

      head status: 200
    end
  end
end
