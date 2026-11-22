module Webhooks
  class GetstreamController < ApplicationController
    include CustomControllerHelpers

    before_action :authenticate_webhook!

    def verify
      render plain: StreamRails.client.api_key
    end

    def notify
      events = JSON.parse(request.body.read)

      GetstreamWebhookParser.new(events).each do |feed, event, activity|
        GetstreamEventWorker.perform_async(feed, event.to_s, activity)
      end

      head 200
    end

    private

    # Checked per request because http_basic_authenticate_with raises while the class loads if the
    # credentials aren't configured, which stops the app from booting. Without them, nobody gets in.
    def authenticate_webhook!
      name = ENV.fetch('STREAM_WEBHOOK_USER', nil)
      password = ENV.fetch('STREAM_WEBHOOK_PASS', nil)
      return request_http_basic_authentication unless name.present? && password.present?

      http_basic_authenticate_or_request_with(name:, password:)
    end
  end
end
