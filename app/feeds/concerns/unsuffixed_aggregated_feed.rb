module UnsuffixedAggregatedFeed
  extend ActiveSupport::Concern

  # Prevent the suffix `_aggr` from being added, by marking it as "flat"
  # rubocop:disable Lint/UnusedMethodArgument
  def stream_feed_for(filter: nil, type: :flat)
    # rubocop:enable lint/UnusedMethodArgument
    super(filter: filter, type: :flat)
  end
  alias_method :stream_feed, :stream_feed_for

  # Unsuffixed aggregated feeds don't automatically follow a corresponding flat
  # feed, so we override the #default_auto_follows method to disable that.
  def default_auto_follows
    []
  end
end
