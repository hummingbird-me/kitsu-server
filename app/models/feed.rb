require 'buffered_stream_client'

# This class is an abstraction on top of Stream Feeds, hiding the details of
# what underlying feeds there are (some "feeds" are actually a group of 6+
# feeds!)
class Feed
  # Feed::DSL provides us with simple, declarative means of building a Feed
  # subclass.
  include DSL

  attr_reader :id

  # Create a new instance of this feed for a given ID.  If given multiple
  # parameters, concatenates them with hyphens in between.
  def initialize(*ids)
    @id = ids.join('-')
  end

  # Follow another Feed, optionally with a scrollback.
  # @param target [Feed|String|#write_target] the target feed to follow
  # @param scrollback [Integer] the number of historical activities to import
  def follow(target, scrollback: 100)
    target = target.write_target if target.respond_to?(:write_target)
    client.feed(*read_target).follow(target, scrollback)
  end

  # Follow multiple Feeds, optionally with a scrollback.
  # @param target [Array<Feed|String|#write_target>] the target feed to follow
  # @param scrollback [Integer] the number of historical activities to import
  def follow_many(targets, scrollback: 30)
    targets.map { |target| follow(target, scrollback: scrollback) }
  end

  # Unfollow another Feed, optionally keeping the history
  # @param target [Feed|String|#write_target] the target feed to follow
  # @param keep_history [Boolean] whether to keep the history from the follow
  def unfollow(target, keep_history: false)
    target = target.write_target if target.respond_to?(:write_target)
    client.feed(*read_target).unfollow(target, keep_history: keep_history)
  end

  # @param target [Array<Feed|String|#write_target>] the target feed to follow
  # @param keep_history [Boolean] whether to keep the history from the follow
  def unfollow_many(targets, keep_history: false)
    targets.map { |target| unfollow(target, keep_history: keep_history) }
  end

  # @return [ActivityList] an activity list representing the data in this feed
  def activities
    Feed::ActivityList.new(self)
  end

  # Adds an activity to the feed
  # @param activity [#as_json] the JSON of the activity to add to the feed
  def add_activity(activity)
    write_feed.add_activity(activity.as_json)
  end

  # Remove an activity from the feed
  # @param activity [#as_json] the JSON of the activity to remove from the feed
  def remove_activity(activity)
    write_feed.remove_activity(activity.as_json)
  end

  def setup!
    follow_many(auto_follows, 100)
  end

  def self.client
    @client ||= BufferedStreamClient.new(StreamRails.client)
  end
  delegate :client, to: :class
  delegate :readonly_token, to: :read_feed

  # @return [Array<String,String>] the default feed target
  def default_target
    [self.class.name.gsub(/\AFeed::|Feed\z/, '').underscore, id]
  end
  alias_method :write_target, :default_target
  alias_method :read_target, :default_target

  def write_feed
    client.feed(*write_target)
  end

  def read_feed
    client.feed(*read_target)
  end

  def self.stream_id_for(obj)
    "#{obj.class.name}:#{obj.id}"
  end

  private

  def auto_follows
    return [] if write_target == read_target
    [write_feed]
  end
end
