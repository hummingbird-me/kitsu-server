class Feed
  class ProfileFeed < Feed
    include MediaUpdatesFilterable
    feed_name 'user'

    def setup!
      Feed::Stream.follow_many(default_auto_follows, 100)
    end

    def no_fanout
      @no_fanout = true
    end

    def stream_activity_target(opts = {})
      if @no_fanout
        super({ type: :aggregated }.merge(opts))
      else
        super(opts)
      end
    end
  end
end
