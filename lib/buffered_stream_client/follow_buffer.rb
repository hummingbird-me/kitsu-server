class BufferedStreamClient
  class FollowBuffer < ActionBuffer
    # Flush things to the RedisFollowBuffer instead of our own approach
    def flush(_client)
      reset.tap do |queue|
        queue.each do |scrollback, follows|
          follows = follows.select do |follow|
            /\A\w+:\w+\z/ =~ follow['source'] && /\A\w+:\w+\z/ =~ follow['target']
          end
          increment_metrics(follows, scrollback: scrollback)
          RedisFollowBuffer.push(scrollback, *follows) unless follows.empty?
        end
      end
    end

    private

    def increment_metrics(follows, tags = {})
      Librato.increment('getstream.follow.sync', tags)
      follows.each do |follow|
        Librato.increment('getstream.follow.total', tags: {
          source_group: follow['source']&.split(':')&.first,
          target_group: follow['target']&.split(':')&.first
        }.merge(tags))
      end
    end
  end
end
