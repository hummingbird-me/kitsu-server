class Feed
  class ProfileFeed < Feed
    include MediaUpdatesFilterable
    feed_name 'user'
  end
end
