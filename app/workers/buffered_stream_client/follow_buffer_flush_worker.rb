class BufferedStreamClient
  class FollowBufferFlushWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'now', retry: false

    def perform
      RedisFollowBuffer.flush_batch
    end
  end
end
