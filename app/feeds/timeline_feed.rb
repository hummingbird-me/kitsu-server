class TimelineFeed < Feed
  def setup!
    # Follow own profile feed
    follow(ProfileFeed.new(id))
  end
end
