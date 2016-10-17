class Feed
  class Activity
    attr_accessor :data, :feed
    %i[actor object target foreign_id verb to time].each do |key|
      define_method("#{key}=") { |value| data[key] = value }
      define_method(key) { data[key] }
    end

    def initialize(feed, data = {})
      @feed = feed
      @data = data
    end

    def as_json(options = {})
      json = data.transform_values { |val| get_stream_id(val) }
      json[:time] = json[:time]&.iso8601
      json[:to] = json[:to]&.compact&.map { |val| get_stream_id(val) }
      json.compact
    end

    def create
      feed.activities.add(self)
    end

    def update
      feed.activities.update(self)
    end

    def destroy
      feed.activities.destroy(self)
    end

    private

    def get_stream_id(obj)
      obj.respond_to?(:stream_id) ? obj.stream_id : obj
    end
  end
end
