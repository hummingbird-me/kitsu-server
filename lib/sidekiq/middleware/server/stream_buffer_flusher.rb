module Sidekiq
  module Middleware
    module Server
      class StreamBufferFlusher
        def call(*)
          yield
        ensure
          Feed.client.try(:flush_async)
        end
      end
    end
  end
end
