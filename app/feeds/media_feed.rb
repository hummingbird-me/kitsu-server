class MediaFeed < Feed
  prepend FanoutOptional

  def read_target
    ['media_aggr', id]
  end

  def write_target
    ['media', id]
  end
end
