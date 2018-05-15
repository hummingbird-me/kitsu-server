class BufferedStreamClient
  class FollowBuffer < RedisBuffer
    # The numbers below are slightly below the max rate limit just for safety
    # We flush 3 queues per batch
    GROUPS_PER_BATCH = 2
    # We can send 250 follow-many requests per 60 seconds
    RATE_LIMIT = 60.seconds / 240 * GROUPS_PER_BATCH
    # Each follow-many is limited to 2500 entries
    BATCH_SIZE = 2_400
    # Match a valid feed name
    VALID_FEED = /\A[\w-]+:[\w-]+\z/i

    def initialize
      super('follows')
    end

    def push(scrollback, *follows)
      follows = follows.select do |follow|
        valid = valid_follow?(follow)
        Raven.capture_message('Invalid Follow', level: 'error', extra: follow) unless valid
        valid
      end
      super(*follows, group: scrollback) unless follows.empty?
    end

    def flush_batch
      groups = longest_groups(GROUPS_PER_BATCH)
      groups.each do |group|
        follows = next_batch_for(group: group, size: BATCH_SIZE)
        next if follows.empty?
        begin
          StreamRails.client.follow_many(follows, group.to_i)
        rescue StandardError
          return_batch(follows, group: group)
          raise
        end
      end
    end

    private

    def valid_follow?(follow)
      valid_feed?(follow['source']) && valid_feed?(follow['target'])
    end

    def valid_feed?(feed)
      VALID_FEED =~ feed
    end

    def increment_metrics(follows, tags = {})
      Librato.increment('getstream.follow.sync', tags)
      Librato.measure('getstream.follow.batch_size', follows.count, tags)
      follows.each do |follow|
        Librato.increment('getstream.follow.total', tags: {
          source_group: follow['source']&.split(':')&.first,
          target_group: follow['target']&.split(':')&.first
        }.merge(tags))
      end
    end
  end
end
