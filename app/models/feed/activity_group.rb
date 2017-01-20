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

    def empty?
      return true if activities.nil?
      activities.empty?
    end
    alias_method :blank?, :empty?

    def sfw?
      activities.all?(&:sfw?)
    end

    def nsfw?
      !sfw?
    end
  end
end
