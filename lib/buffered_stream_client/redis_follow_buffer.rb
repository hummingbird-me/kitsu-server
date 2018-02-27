class BufferedStreamClient
  module RedisFollowBuffer
    module_function

    def push(queue, *items)
      key = key_for(queue)
      items = items.map(&:to_json)
      transaction do |conn|
        # Add the follow to the queue
        conn.lpush(key, *items)
        # Increment our queue length in the list
        conn.zincrby('stream_buffer:queues', items.count, key)
      end
    end

    # Get the next N-sized batch to run from the top N queues
    def next_batch_for(key, size: 100)
      out = transaction do |conn|
        conn.lrange(key, -(size - 1), -1)
        conn.ltrim(key, 0, -size)
        conn.zincrby('stream_buffer:queues', -size, key)
        conn.zremrangebyscore('stream_buffer:queues', '-inf', 0)
      end
      out.first.map { |item| JSON.parse(item) }
    end

    # Get the next queue to pull from
    def next_queues(count = 2)
      $redis.with do |conn|
        conn.zrevrange('stream_buffer:queues', 0, count - 1)
      end
    end

    def flush_batch(count = 2)
      next_queues(count).each do |queue|
        scrollback = /\Astream_buffer:follow_queue:(\d+)\z/.match(queue)[1].to_i
        follows = next_batch_for(queue)
        next if follows.empty?
        StreamRails.client.follow_many(follows, scrollback)
      end
    end

    def transaction(&block)
      $redis.with { |conn| conn.multi(&block) }
    end

    def key_for(key)
      "stream_buffer:follow_queue:#{key}"
    end
  end
end
