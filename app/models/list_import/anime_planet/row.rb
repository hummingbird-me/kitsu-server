class ListImport
  class AnimePlanet
    class Row
      attr_reader :node, :type

      def initialize(node, type)
        @node = node
        @type = type
      end

      def media
        key = "#{type}/#{media_info[:id]}"

        Mapping.lookup('animeplanet', key) ||
          Mapping.guess(type.classify.safe_constantize, media_info)
      end

      def media_info
        {
          id: node.attr('data-id')&.to_i,
          title: extract_title(tooltip),
          show_type: extract_show_type(tooltip),
          episode_count: extract_total_episodes(tooltip),
          chapter_count: extract_total_chapters(tooltip)
        }.compact
      end

      def status
        @status ||= extract_status(tooltip)

        case @status
        when /ing\z/ then :current
        when /\AWant/ then :planned
        when %r{Won't} then nil
        when 'Stalled' then :on_hold
        when 'Dropped' then :dropped
        when 'Watched', /Read([0-9.]+)?/ then :completed
        end
      end

      def progress
        if status == (:completed || :planned || nil)
          if type == 'anime'
            amount = media_info[:episode_count]
          else # manga
            amount = media_info[:chapter_count]
          end
        else
          extract_progress(tooltip)
        end
      end

      def rating
        extract_rating(tooltip)
      end

      def reconsume_count
        if (status == :completed && type == 'anime')
          extract_reconsume_count(tooltip)
        end
      end

      def volumes
        extract_volumes(tooltip) if type == 'manga'
      end

      def data
        %i[status progress rating reconsume_count volumes].map { |k|
          [k, send(k)]
        }.to_h
      end

      private

      def tooltip
        @tooltip ||= Nokogiri::HTML.fragment(
          node.at_css('.tooltip').attr('title')
        )
      end

      # Media Info
      def extract_title(fragment)
        fragment.at_css('h5')&.text
      end

      def extract_show_type(fragment)
        show_type = episodes = fragment.at_css('.entryBar .type')&.text

        episodes&.split(' (')&.first&.strip
      end

      def extract_total_episodes(fragment)
        episodes = fragment.at_css('.entryBar .type')&.text

        episodes&.split(' (')&.last&.gsub(/(ep?s)+/, '')&.to_i
      end

      def extract_total_chapters(fragment)
        chapters = fragment.at_css('.entryBar .iconVol')&.text

        chapters&.split('Ch:')&.last&.tr('+', '')&.to_i
      end

      # Status
      def extract_status(fragment)
        show_type = fragment.at_css('.myListBar')&.content

        show_type&.split(':')&.last&.split('-')&.first&.strip
      end

      # Rating
      def extract_rating(fragment)
        fragment.css('.ttRating')&.last&.text&.to_f
      end

      # Progress
      def extract_progress(fragment)
        amount = fragment.at_css('.myListBar')&.content

        if type === 'anime'
          amount = amount&.split('-')&.last&.split('/')&.first&.strip
        else # manga
          if amount&.include?('chs')
            amount = amount&.split('-')&.last&.split(' ')&.first&.strip
          else
            amount = 0
          end
        end

        amount&.to_i
      end

      # Volumes
      def extract_volumes(fragment)
        amount = fragment.at_css('.myListBar')&.content

        if amount&.include?('vols')
          amount = amount&.split('-')&.last&.split(' ')&.first&.strip
        else
          amount = 0
        end

        amount&.to_i
      end

      # Reconsume Count
      def extract_reconsume_count(fragment)
        amount = fragment.at_css('.myListBar')&.content

        amount&.split('-')&.last&.split('x')&.first&.to_i
      end
    end
  end
end
