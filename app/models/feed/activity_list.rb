class Feed
  class ActivityList
    attr_accessor :data, :feed, :page_number, :page_size, :including,
      :limit_ratio, :termination_reason

    %i[limit offset ranking mark_read mark_seen].each do |key|
      define_method(key) do |value|
        data[key] = value
        self
      end
    end

    def initialize(feed, data = {})
      @feed = feed
      @data = data.with_indifferent_access
      # TODO: :target, :actor and :object are getting forced in by
      # the subreference-enrichment branch of stream-rails.
      # We need a PR for stream-rails to make it optional as it is
      # in their master branch. Better yet, get subreference enrichment
      # in master.
      @including = %w[target actor object]
      @maps = []
      @slow_selects = []
      @fast_selects = []
      @limit_ratio = 1.0
      @page_size = @data[:limit] ||= 25
      @page_number = 1
    end

    def page(page_number = nil, id_lt: nil)
      if page_number
        @page_number = page_number
        update_pagination!
        self
      elsif id_lt
        where_id(:lt, id_lt)
      else
        raise ArgumentError, 'Must provide an offset or id_lt'
      end
    end

    def per(page_size)
      @page_size = page_size
      update_pagination!
      self
    end

    def sfw
      select do |act|
        throw :remove_group if act[:nsfw]
        act[:nsfw] != true
      end
      self
    end

    def blocking(users)
      blocked = Set.new(users)
      # TODO: merge these
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

    def update_pagination!
      return unless page_size && page_number
      data[:limit] = page_size
      data[:offset] = (page_number - 1) * page_size
    end

    def where_id(operator, id)
      data["id_#{operator}"] = id
      self
    end

    def new(data = {})
      Feed::Activity.new(feed, data)
    end

    def find(id)
      act = feed.stream_feed.get(id_lte: id, limit: 1)['results'].first
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
      res = feed.owner_feed.add_activity(activity.as_json)
      res = res.symbolize_keys.except(:duration)
      Feed::Activity.new(feed, res)
    end
    alias_method :<<, :add

    def update(activity)
      Feed.client.update_activity(activity.as_json)
    end

    def destroy(activity = nil, foreign_id: nil, uuid: nil)
      if uuid
        feed.stream_feed.remove_activity(activity)
      else
        foreign_id = Feed.get_stream_id(foreign_id || activity.foreign_id)
        feed.stream_feed.remove_activity(foreign_id, foreign_id: true)
      end
    end

    # @attr [Float] ratio The expected percentage of posts that will be matched
    #                     by this selector
    # @attr [Array<String>] including The attributes which will need to be
    #                                 enriched for this select to work
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

    def map(&block)
      @maps << block
      self
    end

    def empty?
      to_a.empty?
    end

    def to_a
      fetcher.to_a
    end

    def more?
      fetcher.more?
    end

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
        feed: @feed
      }
    end
  end
end
