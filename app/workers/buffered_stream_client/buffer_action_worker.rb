class BufferedStreamClient
  class BufferActionWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'soon'

    def perform(group, id, method, *parameters)
      if method == 'unfollow'
        target_group, target_id, options = parameters
        return @buffer.unfollow_buffer.push(
          options.merge(
            source: "#{group}:#{id}",
            target: "#{target_group}:#{target_id}"
          )
        )
      end
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
