class Feed
  class GroupFeed < Feed
    def setup!
      Feed::Stream.follow_many(default_auto_follows, 100)
    end
  end
end
