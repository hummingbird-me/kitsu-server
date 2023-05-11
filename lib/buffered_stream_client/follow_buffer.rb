# frozen_string_literal: true

class BufferedStreamClient
  class FollowBuffer < RedisBuffer
    # The numbers below are slightly below the max rate limit just for safety
    # We flush 3 queues per batch
    GROUPS_PER_BATCH = 2
    # We can send 250 follow-many requests per 60 seconds
    RATE_LIMIT = 60.seconds / 240 * GROUPS_PER_BATCH
    # Each follow-many is limited to 2500 entries
    BATCH_SIZE = 1_500
    # Match a valid feed name
    VALID_FEED = /\A[\w-]+:[\w-]+\z/i

    def initialize
      super('follows')
    end

    def push(scrollback, *follows)
      follows = follows.select do |follow|
        valid = valid_follow?(follow)
        Sentry.capture_message('Invalid Follow', level: 'error', extra: follow) unless valid
        valid
      end
      super(*follows, group: scrollback) unless follows.empty?
    end

    def flush_batch
      groups = longest_groups(GROUPS_PER_BATCH)
      groups.each do |group|
        follows = next_batch_for(group:, size: BATCH_SIZE)
        next if follows.empty?

        begin
          # TODO: remove this
          follows = follows.map do |follow|
            follow.merge('target' => follow['target'].sub('user:', 'profile:'))
          end
          StreamRails.client.follow_many(follows, group.to_i)
        rescue StandardError
          return_batch_to(follows, group:)
          raise
        end
      end
    end

    private

    def valid_follow?(follow)
      follow = follow.stringify_keys
      valid_feed?(follow['source']) && valid_feed?(follow['target'])
    end

    def valid_feed?(feed)
      VALID_FEED =~ feed
    end
  end
end
