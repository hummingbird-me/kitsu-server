class GroupTimelineFeed < Feed
  # Prevent the suffix `_aggr` from being added, by marking it as "flat"
  def stream_feed_for(filter: nil)
    super(filter: filter, type: :flat)
  end
  alias_method :stream_feed, :stream_feed_for
end
