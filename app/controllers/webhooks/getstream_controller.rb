module Webhooks
  class GetstreamController < ApplicationController
    include CustomControllerHelpers

    http_basic_authenticate_with name: ENV['STREAM_WEBHOOK_USER'],
                                 password: ENV['STREAM_WEBHOOK_PASS']

    def verify
      render text: StreamRails.client.api_key
    end

    def notify
      events = JSON.parse(request.body.read)

      GetstreamWebhookParser.new(events).each do |feed, event, activity|
        GetstreamEventWorker.perform_async(feed, event, activity)
      end

      head status: 200
    end
  end
end
