class TimelineFeed < Feed
  include UnsuffixedAggregatedFeed

  def setup!
    # Follow own profile feed
    follow(ProfileFeed.new(id))
  end
end
