class BufferedStreamClient
  class BufferActionWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'soon'

    def perform(group, id, method, parameters)
      StreamRails.client.feed(group, id).public_send(method, *parameters)
    end
  end
end
