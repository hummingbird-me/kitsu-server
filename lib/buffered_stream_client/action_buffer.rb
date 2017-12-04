class BufferedStreamClient
  # A class for wrapping the buffering of actions to be executed by the client
  class ActionBuffer
    # @param queue [Hash] the queue data to preload
    def initialize(queue = Hash.new { [] })
      @queue = queue
    end

    # Add something to the queue
    #
    # @param key [Object] the key to group the queued items with
    # @param items [Array<Hash>] the items to push into the queue
    # @return [void]
    def push(key, *items)
      @queue[key] += Array.wrap(items)
    end

    # Return the queued data and then eset the queue to its default (empty) state
    #
    # @return [Hash<Object,Array>] the queued data
    def reset
      @queue.tap { @queue = Hash.new { [] } }
    end

    # Flush the queued data to the Stream API
    #
    # @param client [Stream::Client] the client to wrap
    # @return [void]
    def flush(_client)
      raise NotImplementedError
    end

    # Asynchronously flush the queued data to the stream API
    #
    # @return [void]
    def flush_async
      BufferFlushWorker.perform_async(self.class.name, @queue)
    end
  end
end
