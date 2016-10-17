class Feed
  attr_accessor :stream_feed, :group, :id

  def initialize(group, id)
    @group = group.to_s
    @id = id.to_s
    self.stream_feed = client.feed(group, id)
  end

  def activities
    ActivityList.new(self)
  end

  def follow(feed)
    stream_feed.follow(feed.group, feed.id)
  end

  def unfollow(feed)
    stream_feed.unfollow(feed.group, feed.id)
  end

  def stream_id
    "#{group}:#{id}"
  end

  %i[user user_aggr media media_aggr timeline notifications].each do |feed|
    define_singleton_method(feed) { |*args| new(feed, args.join('-')) }
  end

  private

  def self.client
    StreamRails.client
  end
  def client
    self.class.client
  end
end
