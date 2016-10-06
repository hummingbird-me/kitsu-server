class Feed
  attr_accessor :stream_feed, :group, :id

  def initialize(group, id)
    @group = group
    @id = id
    self.stream_feed = client.feed(group, id)
  end

  def activities
    ActivityList.new(self)
  end

  def stream_id
    "#{group}:#{id}"
  end

  %i[user media timeline notifications].each do |feed|
    define_singleton_method(feed) { |*args| new(feed, args.join(':')) }
  end

  private

  def self.client
    StreamRails.client
  end
  def client
    self.class.client
  end
end
