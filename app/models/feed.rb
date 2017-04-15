# This class is an abstraction on top of Stream Feeds, hiding the details of
# what underlying feeds there are (some "feeds" are actually a group of 6+
# feeds!)
class Feed
  # Feed::DSL provides us with simple, declarative means of building a Feed
  # subclass.
  include DSL

  # Common sets of verbs to filter on
  MEDIA_VERBS = %w[updated rated progressed].freeze
  POST_VERBS = %w[post comment follow review].freeze

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
    # Add the follows in one operation
    Feed::Stream.follow_many(follows, scrollback)
  end

  # Get the ActivityList for this Feed, optionally requesting a specific filter
  # and/or type.
  def activities(filter: nil, type: _feed_type)
    feed = Feed::Stream.new({
      type: type,
      filter: filter,
      name: _feed_name
    }, id)
    feed.activities
  end

  # Adds an activity to the feed, automatically adding the filtered feeds to the
  # "to" field
  def self.add_activity(activity, opts = {})
    # Build the "to" field
    activity.to ||= []
    activity.to += stream_activity_targets_for(activity, opts)
    # Send the activity to the target feed
    stream_activity_target(opts).add_activity(activity)
  end

  # Register a feed class for lookups by name
  def self.register!(name, klass)
    @feeds ||= {}
    @feeds[name] = klass
  end

  # Look up the class for a given feed name
  def self.class_for(name)
    @feeds[name]
  end

  private

  def stream_feed
    Feed::Stream.new({ type: _feed_type, name: _feed_name }.merge(opts), id)
  end

  protected

  def stream_follow_target(opts = {})
    Feed::Stream.new({ type: :flat, name: _feed_name }.merge(opts), id)
  end

  def stream_activity_target(opts = {})
    Feed::Stream.new({ type: :flat, name: _feed_name }.merge(opts), id)
  end

  def stream_activity_targets_for(activity, opts = {})
    # Determine which sub-feeds we need to distribute to
    targets = _filters.select { |filter| filter[:proc].call(activity) }
    # And convert them to Feed::Stream instances
    targets.map do |filter|
      Feed::Stream.new({
        type: :flat,
        name: _feed_name,
        filter: filter
      }.merge(opts), id)
    end
  end
end

# Load the feed subfolder so all the classes can register their names
Dir['app/models/feed/*'].each { |file| require_dependency(file) }
