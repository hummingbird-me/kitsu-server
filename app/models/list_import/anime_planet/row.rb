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
          id: extract_id(title_fragment),
          title: node.at_css('.tableTitle').text,
          show_type: node.at_css('.tableType')&.text,
          episode_count: extract_total_episodes(title_fragment),
          chapter_count: extract_total_chapters(title_fragment)
        }.compact
      end

      def status
        case node.at_css('.tableStatus').text.strip
        when 'Watched', 'Read' then :completed
        when /ing\z/ then :current
        when /\AWant/ then :planned
        when 'Stalled' then :on_hold
        when 'Dropped' then :dropped
        end
      end

      def progress
        anime = '.tableEps'
        manga = '.tableCh'

        node.at_css(anime, manga)&.text&.to_i
      end

      def rating
        node.at_css('.tableRating .starrating div').attr('name').to_f
      end

      def reconsume_count
        node.at_css('.tableTimesWatched')&.text&.tr('x','')&.to_i
      end

      def volumes
        node.at_css('.tableVols')&.text&.to_i
      end

      def data
        %i[status progress rating reconsume_count volumes].map do |k|
          [k, send(k)]
        end.to_h
      end

      private

      def title_fragment
        title = node.at_css('.tableTitle a').attr('title')

        Nokogiri::HTML.fragment(title)
      end

      def extract_id(fragment)
        image = fragment.at_css('img').attr('src')

        image.split('-').last.gsub(/(\.)+/, '').to_i
      end

      def extract_total_episodes(fragment)
        episodes = fragment.at_css('.entryBar .type')&.text

        episodes&.split(' (')&.last&.gsub(/(ep?s)+/, '')&.to_i
      end

      def extract_total_chapters(fragment)
        chapters = fragment.at_css('.entryBar .iconVol')&.text

        chapters&.split('Ch:')&.last&.tr('+', '')&.to_i
      end

    end
  end
end
