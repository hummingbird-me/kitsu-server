module Webhooks
  class GetstreamController < ApplicationController
    include CustomControllerHelpers

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
