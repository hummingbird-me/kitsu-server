class Feed
  class ActivityList
    attr_accessor :data, :feed
    %i[limit offset ranking].each do |key|
      define_method(key) do |value|
        self.dup.tap { |al| al.data[key] = value }
      end
    end
    alias_method :per, :limit

    def initialize(feed, data = {})
      @feed = feed
      @data = data
    end

    def page(offset = nil, id_lt: nil)
      if offset
        self.offset(offset)
      elsif id_lt
        self.where_id(:lt, id_lt)
      else
        raise ArgumentError, 'Must provide an offset or id_lt'
      end
    end

    def where_id(operator, id)
      key = "id_#{operator}".to_sym
      self.dup.tap { |al| list.data[key] = id }
    end

    def new(data = {})
      Feed::Activity.new(feed, data)
    end

    def add_activity(activity)
      feed.stream_feed.add_activity(activity.as_json)
    end
    alias_method :<<, :add_activity

    def to_a
      feed.stream_feed.get(data)['results']
    end
  end
end
