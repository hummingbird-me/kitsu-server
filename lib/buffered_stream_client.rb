# This class is wrapper for {Stream::Client} which provides buffering of actions to be executed en
# masse using Stream's bulk APIs.  For example, if a single request makes multiple follow requests,
# we can bundle those up into a single hit to the Stream API and thus make execution more efficient.
# Of course, as with everything else, there's a cost: order of execution is a bit unpredictable, but
# if there's code relying on order of execution with synchronization of data to Stream then it's
# probably bad anyways.
class BufferedStreamClient
  attr_reader :client

  # @param client [Stream::Client] the client to wrap
  def initialize(client)
    @client = client
  end

  # @api getstream-compat
  # @param group [String,#to_s] the feed group
  # @param id [String,#to_s] the feed id
  # @return [JournaledFeed] the feed object
  def feed(group, id)
    BufferedFeed.new(group, id, self)
  end

  # @api getstream-compat
  delegate :update_activities, to: :@feed

  # @api getstream-compat
  # @param follows [Array<Hash>] list of {source:, target:} follows
  # @param scrollback [Integer] number of past posts to get from each feed
  # @return [Hash] a hash with the execution duration
  def follow_many(follows, scrollback)
    duration { follow_buffer.push(scrollback, follows) }
  end

  # Asynchronously flush the queues to Sidekiq
  #
  # @return [void]
  def flush_async
    activity_buffer.flush_async
    follow_buffer.flush_async
  end

  # Generate a realistic timing response hash in case anything depends on that
  #
  # @private
  def self.duration(&block)
    duration = Benchmark.realtime(&block)
    ms = (duration * 1000).round
    { duration: "#{ms}ms" }
  end
  delegate :duration, to: :class

  # @private
  def activity_buffer
    Thread.current[activity_buffer_key] ||= ActivityBuffer.new
  end

  # @private
  def follow_buffer
    Thread.current[follow_buffer_key] ||= FollowBuffer.new
  end

  private

  def follow_buffer_key
    :"_#{object_id}_follows"
  end

  def activity_buffer_key
    :"_#{object_id}_activities"
  end
end
