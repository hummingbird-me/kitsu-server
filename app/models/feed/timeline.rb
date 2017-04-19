class Feed
  class Timeline < Feed
    include MediaUpdatesFilterable

    def stream_feed_for(filter: nil)
      super(filter: filter, type: :flat)
    end
    alias_method :stream_feed, :stream_feed_for

    def setup!
      # Follow own profile feed
      follow(Feed::ProfileFeed.new(id))
    end
  end
end
