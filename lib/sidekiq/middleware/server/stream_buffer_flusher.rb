module Sidekiq
  module Middleware
    module Server
      class StreamBufferFlusher
        def call(*)
          yield
        ensure
          Feed::StreamFeed.client.try(:flush_async)
        end
      end
    end
  end
end
