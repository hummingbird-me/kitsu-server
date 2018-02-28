class Feed
  class ActivityList
    attr_accessor :data, :feed, :including, :limit_ratio
    delegate :client, to: :feed

    %i[limit offset ranking mark_read mark_seen].each do |key|
      define_method(key) do |value|
        data[key] = value
        self
      end
    end

    def initialize(feed, data = {})
      @feed = feed
      @data = data.with_indifferent_access
      @including = %w[target actor object]
      @maps = []
      @slow_selects = []
      @fast_selects = []
      @limit_ratio = 1.0
    end

    def page(id_lt:)
      where_id(:lt, id_lt)
    end

    def per(page_size)
      data[:limit] = page_size
      self
    end

    def unenriched
      @including = []
      self
    end

    def sfw
      select do |act|
        throw :remove_group if act['nsfw']
        !act['nsfw']
      end
      # Handle NSFW posts when the post activity isn't in the group
      select including: %i[target] do |act|
        throw :remove_group if act['target'].is_a?(Post) && act['target'].nsfw?
        !act['nsfw']
      end
      self
    end

    def blocking(user_ids)
      blocked = Set.new(user_ids)
      select do |act|
        user_id = act['actor'].split(':')[1].to_i
        will_block = blocked.include?(user_id)
        throw :remove_group if will_block && act['verb'] == 'post'
        !will_block
      end
      # Handle blocked posts when the post activity isn't in the group
      select including: %i[target] do |act|
        if act['target'].is_a?(Post)
          user_id = act['target'].user_id
          throw :remove_group if blocked.include?(user_id)
        end
        true
      end
      self
    end

    def includes(*relationships)
      including = [relationships].flatten.map(&:to_s)
      # Hardwire subject->object
      including.map! { |inc| inc.sub('subject', 'object') }

      with_subreferences = including.each_with_object({}) do |inc, subs|
        field, reference = inc.split('.')
        (subs[field.to_sym] ||= []) << reference&.to_sym
      end

      including = with_subreferences.map do |field, references|
        references = references&.compact
        references&.any? ? [field, references.uniq] : field
      end

      @including += including
      self
    end

    def mark(type, values = true)
      values = [values] if values.is_a? String
      data["mark_#{type}"] = values
      self
    end

    def where_id(operator, id)
      data["id_#{operator}"] = id
      self
    end

    # Create a new, unsaved Feed::Activity instance for the Feed
    def new(data = {})
      Feed::Activity.new(feed, data)
    end

    def find(id)
      act = feed.get(id_lte: id, limit: 1)['results'].first
      # If we got an ActivityGroup, get the first Activity in it
      act = act['activities'].first if act.key?('activities')

      # If the ID is wrong, the activity doesn't exist in this feed.
      return nil unless act['id'] == id

      # Enrich it
      enricher = StreamRails::Enrich.new(@including)
      enriched_activity = enricher.enrich_activities([act]).first
      # Wrap it
      Feed::Activity.new(feed, enriched_activity)
    end

    def add(activity)
      feed.add_activity(activity.as_json)
      activity
    end
    alias_method :<<, :add

    # Update an existing activity
    #
    # @attr [Feed::Activity,#as_json] activity The activity to add to the feed
    def update(activity)
      client.update_activity(activity.as_json)
    end

    # Destroy an activity by foreign_id, uuid, or Activity instance
    #
    # @attr [Feed::Activity] activity An Activity object to destroy
    # @attr [String] foreign_id The foreign_id of an activity to remove
    # @attr [String] uuid The uuid of an activity to remove
    def destroy(activity = nil, foreign_id: nil, uuid: nil)
      if uuid
        feed.remove_activity(activity)
      else
        foreign_id ||= activity.foreign_id
        foreign_id = foreign_id.stream_id if foreign_id.respond_to?(:stream_id)
        feed.remove_activity(foreign_id, foreign_id: true)
      end
    end

    # Adds a filter step to the ActivityList instance.  If you pass an `including:` value, this will
    # be applied after enrichment, but if you leave it out the execution occurs pre-enrichment,
    # which should be significantly faster, as we skip enrichment entirely for activities which
    # don't match this select.
    # @param ratio [Float] The expected percentage of posts that will be matched by this selector
    # @param including [Array<String>] The attributes which will need to be enriched for this select
    # @return self
    def select(ratio = 1.0, including: nil, &block)
      @limit_ratio *= ratio
      if including
        includes(including)
        @slow_selects << block
      else
        @fast_selects << block
      end
      self
    end

    # Adds a transformation to be applied over each Activity returned by the ActivityList
    # @return self
    def map(&block)
      @maps << block
      self
    end

    delegate :to_a, to: :fetcher
    delegate :empty?, to: :to_a
    delegate :to_enum, to: :fetcher
    delegate :more?, to: :fetcher
    delegate :unread_count, to: :fetcher
    delegate :unseen_count, to: :fetcher

    delegate :read_feed, to: :feed
    delegate :write_feed, to: :feed

    private

    def fetcher
      @fetcher ||= Fetcher.new(
        stream_options: data,
        fetcher_options: fetcher_options
      )
    end

    def fetcher_options
      {
        slow_selects: @slow_selects,
        fast_selects: @fast_selects,
        maps: @maps,
        limit_ratio: @limit_ratio,
        includes: @including,
        feed: feed
      }
    end
  end
end
