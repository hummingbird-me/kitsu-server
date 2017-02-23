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
      @including = []
      @maps = []
      @selects = []
      @limit_ratio = 1.0
      @more = true
      @data[:limit] = 25
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
        throw :remove_group if act.nsfw?
        act.sfw?
      end
      self
    end

    def blocking(users)
      blocked = Set.new(users)
      select do |act|
        user_id = if act.actor.respond_to?(:id)
                    act.actor.id
                  elsif act.actor
                    act.actor.split(':')[1].to_i
                  end
        will_block = blocked.include?(user_id)
        throw :remove_group if will_block && act.verb == 'post'
        !will_block
      end
      self
    end

    def includes(*relationships)
      including = [relationships].flatten.map(&:to_s)
      # Hardwire subject->object
      including.map! { |inc| inc.sub('subject', 'object') }

      with_subreferences = including.inject({}) do |subs, inc|
        field, reference = inc.split('.')
        (subs[field.to_sym] ||= []) << reference&.to_sym
        subs
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
      where_id(:lte, id).limit(1).to_a.first
    end

    def add(activity)
      res = feed.stream_feed.add_activity(activity.as_json)
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
    def select(ratio = 1.0, &block)
      @limit_ratio *= ratio
      @selects << block
      self
    end

    def map(&block)
      @maps << block
      self
    end

    def more?
      to_a if @results.nil?
      @more
    end

    def real_page_size
      [(data[:limit] / @limit_ratio).to_i, 100].min
    end

    def to_a
      return @results if @results
      @results = []
      requested_count = page_size || data[:limit]
      last_id = data[:id_lt]
      loop.with_index do |_, i|
        page_size = [(real_page_size * (1.2**i)).to_i, 100].min
        page = get_page(id_lt: last_id, limit: page_size)
        @results += page if page
        @termination_reason = 'empty' if page.nil?
        @termination_reason = 'iterations' if i >= 10
        @termination_reason = 'full' if @results.count >= requested_count
        if @results.count >= requested_count || i >= 10 || page.nil?
          @results = @results[0..(requested_count - 1)]
          return @results
        end
      end
    end

    def empty?
      to_a.empty?
    end

    private

    def get_page(id_lt: nil, limit: nil)
      # Extract non-pagination payload data
      data = @data.slice(:ranking, :mark_seen, :mark_read, :limit)
      # Apply our id_gt for pagination
      data = data.merge(id_lt: id_lt) if id_lt
      # Apply the limit ratio, apply it to the data
      data[:limit] = limit || real_page_size
      # Actually load results
      res = feed.stream_feed.get(data)['results']
      # If the page we got is the right number, there's more to grab
      @more = res.count == data[:limit]
      return nil if res.count.zero?
      # Enrich them, apply select and map filters to them
      res = enrich(res)
      res = apply_select(res)
      res = apply_maps(res)
      # Remove any nils just to be safe
      res.compact
    end

    # Loads in included associations, converts to Feed::Activity[Group]
    # instances and removes any unfound association data to not break JR
    def enrich(activities)
      enricher = StreamRails::Enrich.new(including)
      if feed.aggregated? || feed.notification?
        activities = enricher.enrich_aggregated_activities(activities)
        activities = activities.map { |ag| Feed::ActivityGroup.new(feed, ag) }
      else
        activities = enricher.enrich_activities(activities)
        activities = activities.map { |a| Feed::Activity.new(feed, a) }
      end
      activities.map { |act| strip_unfound(act) }
    end

    def apply_select(activities)
      activities.lazy.map { |act|
        if act.respond_to?(:activities)
          catch(:remove_group) do
            act.activities = apply_select(act.activities)
            act
          end
        else
          next unless @selects.all? { |proc| proc.call(act) }
          act
        end
      }.reject(&:blank?).to_a
    end

    def apply_maps(activities)
      activities.map do |act|
        if act.respond_to?(:activities)
          act.activities = apply_maps(act.activities)
          act
        else
          @maps.reduce(act) { |acc, elem| elem.call(acc) }
        end
      end
    end

    # Strips unfound
    def strip_unfound(activity)
      # Recurse into activities if we're passed an ActivityGroup
      if activity.respond_to?(:activities)
        activity.dup.tap do |ag|
          ag.activities = activity.activities.map { |a| strip_unfound(a) }
        end
      else
        activity.dup.tap do |act|
          # For each field we've asked to have included
          including.each do |key|
            key = key.first if key.is_a? Array
            # Delete it if it's still a String
            act.delete_field(key) if act[key].is_a? String
          end
        end
      end
    end
  end
end
