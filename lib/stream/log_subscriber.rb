module Stream
  class LogSubscriber < ActiveSupport::LogSubscriber
    def follow(event)
      return unless logger.debug?
      payload = event.payload
      name = format_name('Follow', event.duration, CYAN)
      debug "  #{name}  #{format_follows(payload[:source], payload[:target])}"
    end

    def unfollow(event)
      return unless logger.debug?
      payload = event.payload
      name = format_name('Unfollow', event.duration, CYAN)
      debug "  #{name}  #{format_follows(payload[:source] => payload[:target])}"
    end

    def follow_many(event)
      return unless logger.debug?
      name = format_name('Follow', event.duration, CYAN)
      follows = event.payload[:follows].map { |f| { f[:source] => f[:target] } }
      debug "  #{name}  #{format_follows(follows)}"
    end

    def load(event)
      return unless logger.debug?
      payload = event.payload
      name = format_name('Load Feed', event.duration, MAGENTA)
      debug "  #{name}  #{format_feed(payload[:feed])}  #{payload[:args]}"
    end

    private

    def format_follows(*follows)
      follows = follows.flatten
      follows.flat_map { |follow|
        follow.map { |source, target| "#{format_feed(source)} -> #{format_feed(target)}" }
      }.join(', ')
    end

    def format_name(name, duration, color)
      self.color("#{name} (#{duration.round(1)}ms)", color, true)
    end

    def format_feed(feed)
      ::Feed.get_stream_id(feed)
    end
  end
end
