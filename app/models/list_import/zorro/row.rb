class ListImport
  class Zorro
    class Row
      def initialize(entry)
        @entry = entry
      end

      def media
        Mapping.lookup('aozora', entry['_p_anime'])
      end

      def status
        case entry['status']
        when 'Watching' then :current
        when 'Dropped' then :dropped
        when 'Planning', 'Plan to Watch' then :planned
        when 'Completed' then :completed
        when 'On-Hold' then :on_hold
        end
      end

      def progress
        entry['watchedEpisodes']
      end

      def started_at
        entry['startDate']
      end

      def finished_at
        entry['endDate']
      end

      def rating
        score = entry['score'] * 2
        score.zero? ? nil : score
      end

      def data
        %i[status progress rating started_at finished_at]
          .map { |k|
            [k, send(k)]
          }.to_h
      end
    end
  end
end
