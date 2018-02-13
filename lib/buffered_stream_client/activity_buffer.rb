class BufferedStreamClient
  class ActivityBuffer < ActionBuffer
    BULK_THRESHOLD = 2

    def push(key, *items)
      key = key.stream_id if key.respond_to?(:stream_id)
      super(key, *items)
    end

    def flush(client)
      reset.tap do |queue|
        # Iterate over each feed and submit the activities for it
        queue.each do |feed, activities|
          group, id = feed.split(':')
          feed = client.feed(group, id)

          # If there's not many, send them individually to avoid triggering rate limits
          if activities.count <= BULK_THRESHOLD
            increment_metrics(activities, bulk: false, feed_group: group)
            activities.each do |activity|
              feed.add_activity(activity)
            end
          else
            increment_metrics(activities, bulk: true, feed_group: group)
            feed.add_activities(activities)
          end
        end
      end
    end

    private

    def increment_metrics(activities, tags = {})
      Librato.increment('getstream.add_activity.sync', tags)
      activities.each do |activity|
        Librato.increment('getstream.add_activity.total', tags)
      end
    end
  end
end
