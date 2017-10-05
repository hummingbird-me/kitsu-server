class GetstreamEventWorker
  include Sidekiq::Worker

  def perform(feed, event, activity)
    group, id = feed.split(':')

    case event
    when 'new'
      if group == 'notification'
        user = User.find(id)
        OneSignalNotificationService.new(user, activity).run!
      end
    end
  end
end
