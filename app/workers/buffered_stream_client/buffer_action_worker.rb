class BufferedStreamClient
  class BufferActionWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'soon'

    def perform(group, id, method, *parameters)
      if group && id
        Librato.increment("getstream.#{method}.total", feed_group: group)
        StreamRails.client.feed(group, id).public_send(method, *parameters)
      else
        Librato.increment("getstream.#{method}.total")
        StreamRails.client.public_send(method, *parameters)
      end
    end
  end
end
