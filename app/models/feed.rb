class Feed
  FEED_GROUPS = {
    user_posts: :flat,
    user_media: :flat,
    user_aggr: :aggregated,
    user_posts_aggr: :aggregated,
    user_media_aggr: :aggregated,
    media_posts: :flat,
    media_media: :flat,
    media_aggr: :aggregated,
    media_posts_aggr: :aggregated,
    media_media_aggr: :aggregated,
    group: :flat,
    group_aggr: :aggregated,
    post: :flat,
    reports_aggr: :aggregated,
    timeline: :aggregated,
    timeline_posts: :aggregated,
    timeline_media: :aggregated,
    notifications: :notification,
    global: :aggregated,
    global_posts: :aggregated,
    global_media: :aggregated
  }.freeze

  attr_accessor :stream_feed, :group, :id
  delegate :readonly_token, to: :stream_feed

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

  def ==(other)
    stream_id == other.stream_id
  end

  def flat
    if group.end_with?('_aggr')
      Feed.new(group.sub('_aggr', ''), id)
    else
      self
    end
  end

  def self.follow_many(follows, scrollback: 100)
    follows = follows.map(&:to_a).map(&:flatten)
    stream_follows = follows.map do |(source, target)|
      {
        source: Feed.get_stream_id(source),
        target: Feed.get_stream_id(target)
      }
    end
    client.follow_many(stream_follows, scrollback)
  end

  def stream_id
    "#{group}:#{id}"
  end

  FEED_GROUPS.except(:global, :global_media, :global_posts).keys.each do |feed|
    define_singleton_method(feed) { |*args| new(feed, args.join('-')) }
  end

  FEED_GROUPS.values.uniq.each do |expected_type|
    define_method("#{expected_type}?") { type == expected_type }
  end

  def self.global
    new('global', 'global')
  end

  def self.global_posts
    new('global_posts', 'global')
  end

  def self.global_media
    new('global_media', 'global')
  end

  def type
    FEED_GROUPS[group.to_sym]
  end

  def self.get_stream_id(obj)
    obj.respond_to?(:stream_id) ? obj.stream_id : obj
  end

  private

  def self.client
    StreamRails.client
  end

  def client
    self.class.client
  end
end
