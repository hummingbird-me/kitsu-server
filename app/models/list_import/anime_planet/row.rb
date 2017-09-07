class ListImport
  class AnimePlanet
    class Row
      attr_reader :node, :type

      def initialize(node, type)
        @node = node
        @type = type
      end

      def media
        return @media if @media
        key = "#{type}/#{media_info[:id]}"

        @media = Mapping.lookup('animeplanet', key) ||
                 Mapping.guess_algolia(type.classify.safe_constantize, media_info[:title])
      end

      def media_info
        {
          id: node.attr('data-id')&.to_i,
          title: media_title,
          subtype: subtype,
          episode_count: total_episodes,
          chapter_count: total_chapters
        }.compact
      end

      def status
        @status ||= media_status

        case @status
        when 'status1' then :completed
        when 'status2' then :current
        when 'status3' then :dropped
        when 'status4' then :planned
        when 'status5' then :on_hold
        when 'status6' then nil
        end
      end

      def progress
        if status == :completed
          if type == 'anime'
            media_info[:episode_count]
          else
            media_info[:chapter_count]
          end
        else
          media_progress
        end
      end

      def rating
        ap_rating = node.css('.ttRating')&.last&.text&.to_f
        return unless ap_rating
        (ap_rating * 4).to_i
      end

      def reconsume_count
        return unless type == 'anime' && status == :completed

        amount = tooltip.at_css('.myListBar')&.content
        amount&.split('-')&.last&.split('x')&.first&.to_i
      end

      def volumes
        return unless type == 'manga'

        if status == :completed
          total_volumes
        else
          read_volumes
        end
      end

      def data
        %i[status progress rating reconsume_count].map { |k|
          [k, send(k)]
        }.to_h.compact
      end

      private

      def tooltip
        @tooltip ||= Nokogiri::HTML.fragment(
          node.at_css('.tooltip').attr('title')
        )
      end

      # Media Info
      def media_title
        tooltip.at_css('h5')&.text
      end

      def subtype
        return if type == 'manga'

        episodes = tooltip.at_css('.entryBar .type').text

        episodes.split(' (').first.strip
      end

      def total_episodes
        return if type == 'manga'

        episodes = tooltip.at_css('.entryBar .type').text

        episodes.match(/\d+/).try(:[], 0).to_i
      end

      def total_chapters
        return if type == 'anime'

        chapters = tooltip.at_css('.entryBar .iconVol').text

        chapters.match(/Ch:(\s\d+)/).try(:[], 1).to_i
      end

      def total_volumes
        total = tooltip.at_css('.entryBar .iconVol').text

        total.match(/Vol:(\s\d+)/)[1].to_i
      end

      # Status
      def media_status
        node.at_css('.statusArea [class^=status]')['class']
      end

      # Progress
      def media_progress
        amount = tooltip.at_css('.myListBar').xpath('./text()').to_s.strip

        return 0 if amount.exclude?('-') || amount.include?('vols')

        if type == 'anime'
          amount.split('-').last.split('/').first.to_i
        else
          amount.split('-').last.split(' ').first.to_i
        end
      end

      # Volumes
      def read_volumes
        amount = tooltip.at_css('.myListBar').xpath('./text()').to_s.strip

        return 0 if amount.exclude?('-') || amount.include?('chs')

        amount.split('-').last.split(' ').first.to_i
      end
    end
  end
end
