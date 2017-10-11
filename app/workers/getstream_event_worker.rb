class GetstreamEventWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def perform(feed, event, activity)
    group, id = feed.split(':')
    feed = Feed::StreamFeed.new(group, id)
    activity = Feed::Activity.new(feed, activity)

    case event
    when 'new'
      if group == 'notifications'
        user = User.find(id)
        OneSignalNotificationService.new(user, activity).run!
      end
    end
  end
end
