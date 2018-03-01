class ListImport
  class Aozora
    class Row
      attr_reader :entry

      def initialize(entry)
        @entry = entry
      end

      def media
        Anime.find_by_mapping('aozora', entry['_p_anime'].split('$').last)
      end

      def status
        case entry['list']
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

      def volumes_owned
        0
      end

      def data
        %i[status progress rating started_at finished_at volumes_owned].map { |k|
          [k, send(k)]
        }.to_h
      end
    end
  end
end
