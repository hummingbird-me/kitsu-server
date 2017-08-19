class ActivityDeletionWorker
  include Sidekiq::Worker

  # activities is a structure of [[['user', '5554'], { foreign_id: 'repost:1234' }], ...]
  def perform(activities)
    activities.each do |((group, id), activity)|
      Feed::StreamFeed.new(group, id).activities.destroy(*activity)
    end
  end
end
