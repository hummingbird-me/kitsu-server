class Feed
  class ProfileFeed < Feed
    include MediaUpdatesFilterable
    feed_name 'user'

    def setup!
      Feed::Stream.follow_many(default_auto_follows, 100)
    end
  end
end
