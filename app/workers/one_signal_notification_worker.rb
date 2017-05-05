class OneSignalNotificationWorker
  include Sidekiq::Worker

  def perform(notification)
    getstream_webhook_service = GetstreamWebhookService.new(notificaiton)
  end
end
