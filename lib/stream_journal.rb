# This class is a drop-in replacement for {Stream::Client} which logs to a journal files instead of
# actually uploading to the Stream API, which can then be processed out-of-band as a bulk import.
class StreamJournal
  attr_reader :file
  delegate :close, to: :file

  # @param file [String] the file to journal to
  def initialize(file)
    @file = open(file, 'a')
  end

  # @api getstream-compat
  # @param group [String,#to_s] the feed group
  # @param id [String,#to_s] the feed id
  # @return [JournaledFeed] the feed object
  def feed(group, id)
    JournaledFeed.new(group, id, self)
  end

  # @api getstream-compat
  # @param follows [Array<Hash>] list of {source:, target:} follows
  # @param scrollback [Integer] number of past posts to get from each feed
  # @return [Hash] a hash with the execution duration
  def follow_many(follows, scrollback)
    duration do
      follows.each do |f|
        write(feed: f[:source], action: 'follow', target: f[:target], scrollback: scrollback)
      end
    end
  end

  # Write a JSON-serializable object to the log file.  Needs to be public so that the JournaledFeed
  # can write lines too
  #
  # @param obj [#to_json] the object to log to the journal
  # @private
  def write(obj)
    duration do
      @file.puts Oj.dump(obj)
    end
  end

  # Generate an accurate timing response hash in case anything depends on that
  # @private
  def self.duration(&block)
    duration = Benchmark.realtime(&block)
    ms = (duration * 1000).round
    { duration: "#{ms}ms" }
  end
  delegate :duration, to: :class
end

require_dependency 'stream_journal/journaled_feed'
