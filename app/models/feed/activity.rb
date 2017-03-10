class Feed
  class Activity < OpenStruct
    attr_reader :feed

    def initialize(feed, data = {})
      @feed = feed
      data = data.symbolize_keys
      data[:time] = Time.iso8601(data[:time]) if data[:time].is_a? String
      data[:object] = data[:subject] unless data.key?(:object)
      super(data)
    end

    def as_json(options = {})
      json = to_h.transform_values { |val| Feed.get_stream_id(val) }
      json.symbolize_keys!
      json[:time] = json[:time]&.strftime('%Y-%m-%dT%H:%M:%S%:z')
      json[:to] = json[:to]&.compact&.map { |val| Feed.get_stream_id(val) }
      json.compact
    end

    def sfw?
      !nsfw?
    end

    def nsfw?
      nsfw
    end

    def subject
      object
    end

    def subject=(val)
      self.object = val
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
  end
end
