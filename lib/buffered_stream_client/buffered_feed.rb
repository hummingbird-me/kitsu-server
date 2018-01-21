class StreamJournal
  class BufferedFeed
    # @private
    delegate :duration, to: BufferedStreamClient

    # @api getstream-compat
    delegate :readonly_token, to: :@feed
    delegate :get, to: :@feed
    delegate :following, to: :@feed
    delegate :followers, to: :@feed

    # @private
    # @param group [String,#to_s] the feed group
    # @param id [String,#to_s] the feed id
    # @param client [BufferedStreamClient] the client to buffer in
    def initialize(group, id, buffer)
      @group = group
      @id = id
      @buffer = buffer
      @feed = buffer.client.feed(group, id)
    end

    # @api getstream-compat
    # @param activities [Array<Hash>] the activity object
    # @return [Hash] a hash with the execution duration
    def add_activity(*activities)
      duration do
        activities = Array.wrap(activities).as_json
        @buffer.activity_buffer.push(feed, *activities)
      end
    end
    alias_method :add_activities, :add_activity

    # @api getstream-compat
    # @return [Hash] a hash with the execution duration
    def remove_activity(*args)
      perform_action :unfollow, *args
    end

    # @api getstream-compat
    # @return [Hash] a hash with the execution duration
    def unfollow(*args)
      perform_action :unfollow, *args
    end

    # @api getstream-compat
    # @param group [String,#to_s] the feed group
    # @param id [String,#to_s] the feed id
    # @param activity_copy_limit [Integer] the number of activities to copy
    # @return [Hash] a hash with the execution duration
    def follow(group, id, activity_copy_limit: 300)
      duration do
        @buffer.follow_buffer.push(activity_copy_limit,
          source: "#{@group}:#{@id}",
          target: "#{group}:#{id}")
      end
    end

    private

    def perform_action(action, *args)
      duration do
        BufferActionWorker.perform_async(@group, @id, action, *args)
      end
    end
  end
end
