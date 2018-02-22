class GlobalFeed < Feed
  def initialize(*)
    super('global')
  end

  def stream_feed_for(*)
    %w[global global]
  end
end
