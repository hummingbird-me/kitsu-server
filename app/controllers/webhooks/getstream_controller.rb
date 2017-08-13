module Webhooks
  class GetstreamController < ApplicationController
    include CustomControllerHelpers

    http_basic_authenticate_with name: ENV['STREAM_WEBHOOK_USER'],
                                 password: ENV['STREAM_WEBHOOK_PASS']

    def verify
      render text: StreamRails.client.api_key
    end

    def notify
      notifications = JSON.parse(request.body.read)

      # Since it may be up to 100 per request, send the notifications in background to prevent
      # timeouts and handle errors better.
      notifications.each do |notification|
        OneSignalNotificationWorker.perform_async(notification) unless notification['new'].empty?
      end

      head status: 200
    end
  end
end
