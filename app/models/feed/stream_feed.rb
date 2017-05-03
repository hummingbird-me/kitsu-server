class Feed
  class StreamFeed
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
      ActivityList.new(self)
    end

    def aggregated?
      %w[notifications timeline global].include?(@group) ||
        @group.end_with?('_aggr')
    end

    def stream_feed(*)
      self
    end
    alias_method :stream_feed_for, :stream_feed

    def get(*args)
      client_feed.get(*args)
    end

    def follow(feed)
      client_feed.follow(feed.group, feed.id)
    end

    def unfollow(feed, keep_history: false)
      client_feed.unfollow(feed.group, feed.id, keep_history: keep_history)
    end

    def self.follow_many(follows, scrollback)
      follows = follows.map do |follow|
        follow.transform_values do |value|
          value.respond_to?(:stream_id) ? value.stream_id : value
        end
      end
      StreamRails.client.follow_many(follows, scrollback)
    end

    def stream_id
      "#{@group}:#{@id}"
    end

    def self.client
      StreamRails.client
    end

    private

    def client
      StreamRails.client
    end

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
  end
end
