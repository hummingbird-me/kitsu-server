class BufferedStreamClient
  class FollowBuffer < ActionBuffer
    BULK_THRESHOLD = 2

    def flush(client)
      reset.tap do |queue|
        # Iterate over the scrollback sizes
        queue.each do |scrollback, follows|
          # If there's not many, send them individually to avoid triggering rate limits
          if follows.count <= BULK_THRESHOLD
            follows.each do |follow|
              group, id = follow[:source].split(':')
              feed = client.feed(group, id)
              feed.follow(follow[:target], activity_copy_limit: scrollback)
            end
          else
            client.follow_many(*follows, activity_copy_limit: scrollback)
          end
        end
      end
    end
  end
end
