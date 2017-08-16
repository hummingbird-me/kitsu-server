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

    def as_json(_options = {})
      json = to_h.transform_values { |val| Feed.get_stream_id(val) }
      json.symbolize_keys!
      json[:time] = json[:time]&.strftime('%Y-%m-%dT%H:%M:%S%:z')
      json[:to] = json[:to]&.compact&.flat_map do |val|
        res = []
        # Base Feed
        res << val.stream_activity_target if val.respond_to?(:stream_activity_target)
        # Sub-Feeds
        if val.respond_to?(:stream_activity_targets_for)
          res += val.stream_activity_targets_for(self)
        end
        # Fallback for non-Feed values passed in
        res << val if res.empty?
        res
      end
      json[:to] = json[:to]&.map { |val| Feed.get_stream_id(val) }
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

    def origin
      origin_feed = super
      if origin_feed
        Feed.new(*origin_feed.split(':'))
      else
        feed
      end
    end

    def group
      @group ||= feed.activities.find_group_for(id)
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

    def destroy_original
      origin.activities.destroy(self)
    end
  end
end
