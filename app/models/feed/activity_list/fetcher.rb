class Feed
  class ActivityList
    class Fetcher
      attr_reader :stream_options, :fetcher_options, :unread_count,
        :unseen_count

      def initialize(stream_options: {}, fetcher_options: {})
        @stream_options = stream_options.deep_symbolize_keys
        @fetcher_options = fetcher_options.deep_symbolize_keys
        @data = []
        @pages = 0
        @termination_reason = nil
        @next_page = {}
      end

      def to_a
        return @data if @termination_reason

        @termination_reason = loop do
          break :iterations if @pages >= 10
          break :full if full?
          break :end if end?
          get_page!
        end

        @data = @data[0..(goal_count - 1)]
        @data
      end

      def to_enum
        Enumerator.new { |yielder|
          opts = stream_options.merge(limit: 100)
          next_page = {}

          loop do
            # Generate the options
            opts = opts.merge(next_page)
            # Grab the page
            page = feed.stream_feed.get(opts)['results']
            # Record the next page info
            next_page = get_next_page(page)
            # If we got less than we asked for, we've hit the final page
            raise StopIteration if page.count < 100
            # Filter the page and tack it onto the list
            page = Page.new(page, fetcher_options).to_a
            # Iterate over the page and yield it
            page.each { |act| yielder << act }
          end
        }.lazy
      end

      def more?
        @termination_reason != :end
      end

      private

      def feed
        fetcher_options[:feed]
      end

      def full?
        @data.count >= goal_count
      end

      def end?
        @next_page.nil?
      end

      def page_size_for(page = 1)
        page_size = (base_page_size * (1.2**page)).to_i
        [page_size, 100].min
      end

      def base_page_size
        goal_count / limit_ratio
      end

      def limit_ratio
        fetcher_options[:limit_ratio] || 1.0
      end

      def goal_count
        stream_options[:limit] || 25
      end

      def get_page! # rubocop:disable Style/AccessorMethodName
        @pages += 1
        # Generate the page size
        page_size = page_size_for(@pages)
        # Generate the options
        opts = stream_options.merge(@next_page)
        opts = opts.merge(limit: page_size)
        # Grab the page
        res = feed.stream_feed.get(opts)
        page = res['results']
        # Store the counts
        @unread_count = res['unread']
        @unseen_count = res['unseen']
        # Record the next page info
        @next_page = get_next_page(page)
        # If we got less than we asked for, we've hit the final page
        @next_page = nil if page.count < page_size
        # Filter the page and tack it onto the list
        @data += Page.new(page, fetcher_options).to_a
      end

      # Gets the id_lt/id_gt of the next page, for a given page of data
      def get_next_page(data)
        if pagination_direction == :lt
          { id_lt: data.last&.[]('id') }
        else
          { id_gt: data.first&.[]('id') }
        end
      end

      #  Get the direction of the pagination
      def pagination_direction
        stream_options[:id_gt] || stream_options[:id_gte] ? :gt : :lt
      end
    end
  end
end
