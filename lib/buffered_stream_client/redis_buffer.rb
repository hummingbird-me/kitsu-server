class BufferedStreamClient
  # A system for buffering actions to be sent in groups to Stream's API.  This can be used for
  # anything which is batchable, even if the batches have to be grouped by a sub-key (for example,
  # follows need to be sent in batches grouped by the size of the scrollback).  For things which
  # are not grouped by a subkey, the subkey can be constant.
  #
  # The buffers should be asynchronously flushed by a background task at a rate chosen to prevent
  # hitting rate limits.  The sub-keys are queued separately with counts maintained of each one, and
  # when the buffer is flushed it picks the largest X of the sub-queues and then picks the top Y
  # from each of those queues.
  #
  # Because the action of getting the longest queues is separate from the action of retrieving items
  # from the queue, there's always the possibility of race conditions in a distributed system, but
  # this should be harmless since it would just attempt to execute an empty list of actions or a
  # smaller list than it expected.  This should resolve itself by the next tick.
  #
  # If execution results in an error, it will return the batch to Redis. However, if the runtime
  # crashes, the batch can be lost.  If that's an issue, don't use this system.
  class RedisBuffer
    # @param queue [String,#to_s] the name of the buffer
    def initialize(queue)
      @queue = queue
    end

    # Add a list of items to the queue, with an optional grouping
    #
    # @param items [Array<#to_json>] the list of JSON-serializable items to push to the queue
    # @param group [String,#to_s] the key for grouping these items in the queue
    def push(*items, group: 'default')
      key = key_for(group)
      items = items.map(&:to_json)
      multi do |conn|
        # Add the follow to the queue
        conn.lpush(key, items)
        # Increment our queue length in the list
        conn.zincrby(groups_key, items.count, key)
      end
    end

    private

    # Pop N items from the end of a group in this queue
    # @param group [String,#to_s] the key for the group to get a batch from
    # @param size [Integer] the number of items to get
    def next_batch_for(group: 'default', size: 2000)
      key = key_for(group)
      out = multi do |conn|
        conn.lrange(key, -(size - 1), -1)
        conn.ltrim(key, 0, -size)
        conn.zincrby(groups_key, -size, key)
        conn.zremrangebyscore(groups_key, '-inf', 0)
      end
      out.first.map { |item| JSON.parse(item) }
    end

    # Push a failed batch back to Redis for re-execution
    # @param group [String,#to_s] the key for grouping these items in the queue
    # @param items [Array<#to_json>] the list of JSON-serializable items to return to the front of
    #   the queue
    def return_batch_to(items, group: 'default')
      key = key_for(group)
      multi do |conn|
        conn.rpush(key, *items)
        conn.zincrby(groups_key, items.count, key)
      end
    end

    # Get the N longest groups in this queue, to be executed next
    #
    # @param count [Integer] the number of groups to return
    def longest_groups(count = 2)
      keys = $redis.with { |conn| conn.zrevrange('stream_buffer:groups', 0, count - 1) }
      keys.map(&method(:group_for))
    end

    # Run a list of Redis commands in a MULTI block
    def multi(&block)
      $redis.with { |conn| conn.multi(&block) }
    end

    # The Redis key for a given group
    def key_for(group)
      "stream_buffer:#{@queue}:#{group}"
    end

    # The group for a given Redis key
    def group_for(key)
      /stream_buffer:#{@queue}:([^:]+)/.match(key)[1]
    end

    # The key for storing group lengths
    def groups_key
      "stream_buffer:#{@queue}:groups"
    end
  end
end
