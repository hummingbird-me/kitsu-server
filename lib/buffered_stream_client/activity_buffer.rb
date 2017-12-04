class BufferedStreamClient
  class ActivityBuffer < ActionBuffer
    BULK_THRESHOLD = 2

    def flush(client)
      reset.tap do |queue|
        # Iterate over each feed and submit the activities for it
        queue.each do |feed, activities|
          group, id = feed.split(':')
          feed = client.feed(group, id)

          # If there's not many, send them individually to avoid triggering rate limits
          if activities.count <= BULK_THRESHOLD
            activities.each do |activity|
              feed.add_activity(activity)
            end
          else
            feed.add_activities(activities)
          end
        end
      end
    end
  end
end
