class BufferedStreamClient
  class FollowBuffer < ActionBuffer
    BULK_THRESHOLD = 2

    def flush(client)
      reset.tap do |queue|
        # Iterate over the scrollback sizes
        queue.each do |scrollback, follows|
          # If there's not many, send them individually to avoid triggering rate limits
          if follows.count <= BULK_THRESHOLD
            increment_metrics(follows, bulk: false, scrollback: scrollback)
            follows.each do |follow|
              group, id = follow['source'].split(':')
              feed = client.feed(group, id)
              target_group, target_id = follow['target'].split(':')
              feed.follow(target_group, target_id, activity_copy_limit: scrollback)
            end
          else
            increment_metrics(follows, bulk: true, scrollback: scrollback)
            client.follow_many(follows, activity_copy_limit: scrollback)
          end
        end
      end
    end

    private

    def increment_metrics(follows, tags = {})
      Librato.increment('getstream.follow.sync', tags)
      follows.each do |follow|
        Librato.increment('getstream.follow.total', tags: {
          source_group: follow['source']&.split(':')&.first,
          target_group: follow['target']&.split(':')&.first
        }.merge(tags))
      end
    end
  end
end
