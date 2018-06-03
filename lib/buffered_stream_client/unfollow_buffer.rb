class BufferedStreamClient
  class UnfollowBuffer < RedisBuffer
    # The numbers below are slightly below the max rate limit just for safety
    # We can send 250 unfollow requests per 60 seconds
    RATE_LIMIT = 60.seconds / 240
    # Match a valid feed name
    VALID_FEED = /\A[\w-]+:[\w-]+\z/i

    def initialize
      super('unfollows')
    end

    def push(*unfollows)
      unless unfollows.all? { |f| valid_follow?(f) }
        return Raven.capture_message('Invalid Unfollow', level: 'error', extra: f)
      end
      super(*unfollows, group: 'default')
    end

    def flush_batch
      # TODO: switch to unfollow-many
      unfollow = next_batch_for(size: 1).first
      return unless unfollow
      begin
        source = unfollow['source'].split(':')
        target = unfollow['target'].split(':')
        feed = StreamRails.client.feed(*source)
        feed.unfollow(*target, unfollow['keep_history'])
      rescue StandardError
        return_batch_to([unfollow], group: 'default')
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
