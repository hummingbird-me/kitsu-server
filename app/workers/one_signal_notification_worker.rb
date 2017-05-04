class OneSignalNotificationWorker
  include Sidekiq::Worker

  def perform(notification)
    serialized_activity = GetstreamService.new(notificaiton).serialize!
    OneSignalNotificationService.new(serialized_activity.actor, serialized_activity.content, serialized_activity.url).send! if serialized_activity
  end
end
