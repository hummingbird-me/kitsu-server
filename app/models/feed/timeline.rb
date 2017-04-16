class Feed
  class Timeline < Feed
    include MediaUpdatesFilterable

    def setup!
      # Follow own profile feed
      follow(Feed::ProfileFeed.new(id))
    end
  end
end
