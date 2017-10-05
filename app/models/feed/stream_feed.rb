class Feed
  class StreamFeed
    class_attribute :client
    attr_reader :group, :id, :client_feed, :owner_feed

    delegate :readonly_token, to: :client_feed
    delegate :add_activity, to: :client_feed
    delegate :remove_activity, to: :client_feed

    def initialize(group, id, owner_feed: nil)
      @group = group_name_for(group)
      @id = id
      @client_feed = client.feed(@group, @id)
      @owner_feed = owner_feed
    end

    def activities(*)
      ActivityList.new(self).with_type(aggregated? ? :aggregated : :flat)
    end

    def aggregated?
      %w[notifications timeline group_timeline global
         site_announcements interest_timeline].include?(@group) ||
        @group.end_with?('_aggr')
    end

    def stream_feed(*)
      self
    end
    alias_method :stream_feed_for, :stream_feed

    def get(*args)
      instrument('load', args: args, feed: self) do
        client_feed.get(*args)
      end
    end

    def follow(feed)
      instrument('follow', source: client_feed, target: feed) do
        client_feed.follow(feed.group, feed.id)
      end
    end

    def unfollow(feed, keep_history: false)
      instrument('unfollow', source: self, target: feed) do
        client_feed.unfollow(feed.group, feed.id, keep_history: keep_history)
      end
    end

    def self.follow_many(follows, scrollback)
      follows = follows.map do |follow|
        follow.transform_values do |value|
          value.respond_to?(:stream_id) ? value.stream_id : value
        end
      end
      instrument('follow_many', follows: follows, scrollback: scrollback) do
        client.follow_many(follows, scrollback)
      end
    end

    def stream_id
      "#{@group}:#{@id}"
    end

    def self.client
      @client ||= StreamRails.client
    end

    def self.instrument(key, extra = {}, &block)
      ActiveSupport::Notifications.instrument("#{key}.getstream", extra, &block)
    end

    private

    def group_name_for(group)
      if group.respond_to?(:to_h)
        # Extract the attributes to build the group name
        name, filter, type = group.to_h.values_at(:name, :filter, :type)
        # Convert aggregated feed to "aggr"
        type = type == :aggregated ? 'aggr' : nil
        # Build it to be `name_filter_type`
        [name, filter, type].compact.join('_')
      else
        group
      end
    end

    def instrument(key, extra = {}, &block)
      self.class.instrument(key, extra, &block)
    end
  end
end
