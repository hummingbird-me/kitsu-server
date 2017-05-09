# This class is an abstraction on top of Stream Feeds, hiding the details of
# what underlying feeds there are (some "feeds" are actually a group of 6+
# feeds!)
class Feed
  # Feed::DSL provides us with simple, declarative means of building a Feed
  # subclass.
  include DSL

  # Common sets of verbs to filter on
  MEDIA_VERBS = %w[updated rated progressed].to_set.freeze
  POST_VERBS = %w[post comment follow review].to_set.freeze

  attr_reader :id

  # Create a new instance of this feed for a given ID.  If given multiple
  # parameters, concatenates them with hyphens in between.
  def initialize(*ids)
    @id = ids.join('-')
  end

  # Follow another Feed, optionally with a scrollback.
  # Under the hood, this actually calls {#follows_for}, which generates a list
  # of follows (correlating common filters) and then sends it to
  # {Feed::Stream#follow_many}, to perform the follow in one fell swoop.
  def follow(target, scrollback: 100)
    # Add the follows in one follow_many operation
    Feed::StreamFeed.follow_many(follows_for(target), scrollback)
  end

  # Unfollow another Feed, optionally keeping the history
  def unfollow(target, keep_history: false)
    # Stream doesn't provide an unfollow_many method, so we just gotta settle
    # for this nontransactional pile of crap.
    # Get the follows
    follows_for(target).each do |follow|
      # And unfollow each of 'em
      follow[:source].unfollow(follow[:target], keep_history: keep_history)
    end
  end

  # Compare two Feed instances.  Basically, compare feed name and ID
  def ==(other)
    _feed_name == other._feed_name && id == other.id
  end

  # Get the ActivityList for this Feed, optionally requesting a specific filter
  # and/or type.
  def activities_for(filter: nil, type: nil)
    Feed::ActivityList.new(self).filter(filter).with_type(type)
  end
  alias_method :activities, :activities_for

  # Get the stream feed for a given filter+type of the current feed instance
  def stream_feed_for(filter: nil, type: _feed_type)
    Feed::StreamFeed.new({
      type: type,
      filter: filter,
      name: _feed_name
    }, id, owner_feed: self)
  end

  # shorthand+fastpath for the default stream feed
  def stream_feed
    @stream_feed ||= stream_feed_for
  end

  # Adds an activity to the feed, automatically adding the filtered feeds to the
  # "to" field
  def add_activity(activity, opts = {})
    # Build the "to" field
    activity[:to] ||= []
    cc_to = stream_activity_targets_for(activity, opts).map(&:stream_id)
    activity[:to] += cc_to
    # Send the activity to the target feed
    stream_activity_target(opts).add_activity(activity)
  end

  # Pass right along to stream_feed
  delegate :remove_activity, to: :stream_feed
  delegate :get, to: :stream_feed

  # Register a feed class for lookups by name
  def self.register!(name, klass)
    @feeds ||= {}
    @feeds[name] = klass
  end

  # Look up the class for a given feed name
  def self.class_for(name)
    (@feeds && @feeds[name])
  end

  def self.feeds
    @feeds || {}
  end

  # Temporary compatibility stuff
  # TODO: remove these
  def self.method_missing(name, *args)
    class_for(name.to_s)&.new(*args) || super
  end

  def self.get_stream_id(obj)
    if obj.respond_to?(:stream_id)
      obj.stream_id
    else
      obj
    end
  end

  def self.respond_to_missing?(name, include_private = false)
    (@feeds && @feeds.key?(name.to_s)) || super
  end

  def setup!
    Feed::StreamFeed.follow_many(default_auto_follows, 100)
  end

  delegate :stream_id, to: :stream_feed
  delegate :readonly_token, to: :stream_feed

  def stream_follow_target(opts = {})
    Feed::StreamFeed.new({ type: :flat, name: _feed_name }.merge(opts), id)
  end

  def stream_activity_target(opts = {})
    Feed::StreamFeed.new({ type: :flat, name: _feed_name }.merge(opts), id)
  end

  def stream_activity_targets_for(activity, opts = {})
    # Determine which sub-feeds we need to distribute to
    targets = _filters.select { |_name, filter| filter[:proc].call(activity) }
    targets = targets.keys
    # And convert them to Feed::Stream instances
    targets.map do |filter|
      Feed::StreamFeed.new({
        type: :flat,
        name: _feed_name,
        filter: filter
      }.merge(opts), id)
    end
  end

  def aggregated?
    _feed_type == :aggregated || _feed_type == :notification
  end

  private

  def follows_for(target)
    # Directly follow the target
    follows = [{ source: stream_feed, target: target.stream_follow_target }]
    # Get the intersection of the filter sets and create any necessary follows
    shared_filters = self.class.filters_shared_with(target.class)
    follows += shared_filters.map do |filter|
      {
        source: stream_feed(filter: filter),
        target: target.stream_follow_target(filter: filter)
      }
    end
    # And finally, return the result
    follows
  end

  # Generate a set of "default" auto follows, basically matching the filters to
  # their aggregations
  def default_auto_follows
    return unless _feed_type == :aggregated
    base_follow = { source: stream_feed, target: stream_activity_target }
    filter_follows = _filters.map do |filter, options|
      {
        source: Feed::StreamFeed.new({
          type: :aggregated,
          name: _feed_name,
          filter: filter
        }, id),
        target: Feed::StreamFeed.new({
          type: :flat,
          name: _feed_name,
          filter: filter
        }, id)
      }
    end

    [base_follow, *filter_follows]
  end
end
