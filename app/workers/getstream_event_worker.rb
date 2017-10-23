class GetstreamEventWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def perform(feed, event, activity)
    group, id = feed.split(':')
    feed = Feed::StreamFeed.new(group, id)

    case event
    when 'new'
      activity = Feed::Activity.new(feed, activity)
      if group == 'notifications'
        user = User.find(id)
        OneSignalNotificationService.new(user, activity).run!
      end
    end
  end
end
