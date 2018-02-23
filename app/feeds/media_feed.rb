class MediaFeed < Feed
  include FanoutOptional

  def read_feed
    ['media_aggr', id]
  end

  def write_feed
    ['media', id]
  end
end
