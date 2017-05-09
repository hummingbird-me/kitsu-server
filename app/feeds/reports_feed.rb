class ReportsFeed < Feed
  feed_type :aggregated

  def stream_activity_target(opts = {})
    Feed::StreamFeed.new({
      type: :aggregated,
      name: _feed_name
    }.merge(opts), id)
  end
end
