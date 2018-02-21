class GlobalFeed < Feed
  def initialize(*)
    super('global')
  end

  def stream_feed_for(filter: nil, type: :flat)
    super(filter: filter, type: type)
  end
end
