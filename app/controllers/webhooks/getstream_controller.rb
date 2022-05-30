module Webhooks
  class GetstreamController < ApplicationController
    include CustomControllerHelpers

    http_basic_authenticate_with name: ENV.fetch('STREAM_WEBHOOK_USER', nil),
      password: ENV.fetch('STREAM_WEBHOOK_PASS', nil)

    def verify
      render plain: StreamRails.client.api_key
    end

    def notify
      events = JSON.parse(request.body.read)

      GetstreamWebhookParser.new(events).each do |feed, event, activity|
        GetstreamEventWorker.perform_async(feed, event, activity)
      end

      head :ok
    end
  end
end
