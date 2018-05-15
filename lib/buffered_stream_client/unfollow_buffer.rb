class BufferedStreamClient
  class UnfollowBuffer < RedisBuffer
    # The numbers below are slightly below the max rate limit just for safety
    # We can send 250 unfollow requests per 60 seconds
    RATE_LIMIT = 60.seconds / 240 * GROUPS_PER_BATCH
    # Match a valid feed name
    VALID_FEED = /\A[\w-]+:[\w-]+\z/i

    def initialize
      super('unfollows')
    end

    def push(unfollow)
      unless valid_follow?(unfollow)
        return Raven.capture_message('Invalid Unfollow', level: 'error', extra: unfollow)
      end
      super(unfollow)
    end

    def flush_batch
      # TODO: switch to unfollow-many
      unfollow = next_batch_for(size: 1).first
      begin
        feed = StreamRails.client.feed(*unfollow['source'])
        feed.unfollow(*unfollow['target'], unfollow['keep_history'])
      rescue StandardError
        return_batch([unfollow])
        raise
      end
      increment_metrics([unfollow])
    end

    private

    def valid_follow?(follow)
      follow = follow.stringify_keys
      valid_feed?(follow['source']) && valid_feed?(follow['target'])
    end

    def valid_feed?(feed)
      VALID_FEED =~ feed
    end

    def increment_metrics(unfollows, tags = {})
      Librato.increment('getstream.unfollow.sync', tags)
      Librato.measure('getstream.unfollow.batch_size', unfollows.count, tags)
      unfollows.each do |unfollow|
        Librato.increment('getstream.unfollow.total', tags: {
          source_group: unfollow['source']&.split(':')&.first,
          target_group: unfollow['target']&.split(':')&.first
        }.merge(tags))
      end
    end
  end
end
