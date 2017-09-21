class Feed
  # This class is a replacement for Stream::Client which logs to a journal instead of actually
  # uploading to Stream API
  class Journal
    ACTIONS = %i[activities follows].freeze
    attr_reader :dir

    # Initializes the directory structure for usage
    #
    # ./activities/user$5554.ndjson
    # ./follows/user$5554.ndjson
    def initialize(dir)
      @dir = File.realpath(dir)

      # Generate directories for each of the known actions
      ACTIONS.each do |action|
        FileUtils.mkpath(File.join(@dir, action.to_s))
      end
    end

    def file(group, id, action = nil)
      JournalFile.new(self, group, id, action)
    end

    def write_activity(group, id, data)
      write_to(group, id, 'activities', data.to_json)
    end

    def feed(group, id)
      Feed.new(group, id, self)
    end

    # follows = [{:source, :target}, ...]
    def follow_many(follows, scrollback)
      duration do
        follows.group_by { |f| f[:source] }.each do |source, targets|
          f = file(source, 'follows')
          f.open!
          targets.each do |target|
            f << "follow,#{target[:target]},#{scrollback}"
          end
          f.close!
        end
      end
    end

    def self.duration(&block)
      duration = Benchmark.realtime(&block)
      ms = (duration * 1000).round
      { duration: "#{ms}ms" }
    end
    delegate :duration, to: :class

    class Feed
      delegate :duration, to: :Journal

      def initialize(group, id, journal)
        @group = group
        @id = id
        @journal = journal
      end

      def add_activity(act)
        duration do
          file(group, id, 'activities') << "add,#{act.to_json}"
        end
      end

      def remove_activity(id, foreign_id: false)
        duration do
          file(group, id, 'activities') << "remove,#{id},foreign_id=#{foreign_id}"
        end
      end

      def readonly_token(*)
        raise NotImplementedError
      end

      def get(*)
        raise NotImplementedError
      end

      def unfollow(group, id, keep_history: false)
        duration do
          file(group, id, 'follows') << "unfollow,#{group}:#{id},#{keep_history}"
        end
      end

      def follow(group, id, *)
        duration do
          file(group, id, 'follows') << "follow,#{group}:#{id}"
        end
      end

      delegate :file, to: :journal
    end

    class JournalFile
      def initialize(journal, group, id, action = nil)
        # If action is left out, the params are actually (journal, feed, action)
        # How I yearn for the function declarations of Elixir
        filename = action.nil? ? group.sub(':', '$') : "#{group}$#{id}"
        action = id if action.nil?
        @file = File.join(journal.dir, action, filename)
      end

      def <<(line)
        if @handle
          @handle.puts line
        else
          open(@file, 'a') { |f| f.puts line }
        end
      end

      def open!
        @handle = open(@file, 'a')
      end

      def close!
        @handle.close
      end
    end
  end
end
