class BufferedStreamClient
  class BufferFlushWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'soon'

    def perform(klass_name, queue)
      klass = klass_name.safe_constantize
      buffer = klass.new(queue)
      buffer.flush(StreamRails.client)
    end
  end
end
