class Feed
  class ActivityList
    attr_accessor :data, :feed, :page_number, :page_size
    %i[limit offset ranking].each do |key|
      define_method(key) do |value|
        self.dup.tap { |al| al.data[key] = value }
      end
    end
    alias_method :per, :limit

    def initialize(feed, data = {})
      @feed = feed
      @data = data.with_indifferent_access
    end

    def page(page_number = nil, id_lt: nil)
      if page_number
        dup.tap do |al|
          al.page_number = page_number
          al.update_pagination! if page_size
        end
      elsif id_lt
        self.where_id(:lt, id_lt)
      else
        raise ArgumentError, 'Must provide an offset or id_lt'
      end
    end

    def per(page_size)
      dup.tap do |al|
        al.page_size = page_size
        al.update_pagination! if page_number
      end
    end

    def update_pagination!
      data[:limit] = page_size
      data[:offset] = (page_number - 1) * page_size
    end

    def where_id(operator, id)
      self.dup.tap { |al| al.data["id_#{operator}"] = id }
    end

    def new(data = {})
      Feed::Activity.new(feed, data)
    end

    def add(activity)
      feed.stream_feed.add_activity(activity.as_json)
    end
    alias_method :<<, :add

    def update(activity)
      Feed.client.update_activity(activity.as_json)
    end

    def destroy(activity)
      feed.stream_feed.remove_activity(activity.foreign_id, foreign_id: true)
    end

    def results
      feed.stream_feed.get(data)['results']
    end

    def to_a
      results.map do |result|
        if result.key?('activities')
          Feed::ActivityGroup.new(feed, result)
        else
          Feed::Activity.new(feed, result)
        end
      end
    end
  end
end
