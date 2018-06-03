class BufferedStreamClient
  class UnfollowBufferFlushWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'now', retry: false

    def perform
      UnfollowBuffer.new.flush_batch
    end
  end
end
