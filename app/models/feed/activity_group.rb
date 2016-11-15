class Feed
  class ActivityGroup < OpenStruct
    attr_reader :feed

    def initialize(feed, data = {})
      @feed = feed
      data = data.symbolize_keys
      data[:activities] = data[:activities]&.map do |activity|
        Feed::Activity.new(feed, activity)
      end
      super(data)
    end
  end
end
