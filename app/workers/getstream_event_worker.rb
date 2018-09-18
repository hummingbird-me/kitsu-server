class GetstreamEventWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def perform(feed, event, activity)
    group, id = feed.split(':')
    feed = Feed.new(group, id)

    case event
    when 'new'
      activity = Feed::Activity.new(feed, activity)
      if group == 'notifications'
        user = User.find_by(id: id)
        return unless user
        OneSignalNotificationService.new(user, activity).run!
      end
    end
  end
end
