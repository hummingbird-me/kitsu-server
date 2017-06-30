class TimelineFeed < Feed
  include MediaUpdatesFilterable

  # Prevent the suffix `_aggr` from being added, by marking it as "flat"
  # rubocop:disable Lint/UnusedMethodArgument
  def stream_feed_for(filter: nil, type: :flat)
    # rubocop:enable lint/UnusedMethodArgument
    super(filter: filter, type: :flat)
  end
  alias_method :stream_feed, :stream_feed_for

  def setup!
    # Follow own profile feed
    follow(ProfileFeed.new(id))
  end
end
