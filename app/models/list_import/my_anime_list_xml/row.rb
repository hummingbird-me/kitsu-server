class ListImport
  class MyAnimeListXML
    class Row
      attr_reader :node

      def initialize(node)
        raise "Invalid type #{node.name}" unless node.name.in? %w[anime manga]
        @node = node
      end

      def type
        node.name.classify.safe_constantize
      end

      def media
        key = "myanimelist/#{node.name}"
        Mapping.lookup(key, media_info[:id]) || Mapping.guess_algolia(type, media_info[:title])
      end

      def media_info
        @media_info ||= {
          id: node.at_css('manga_mediadb_id, series_animedb_id').content.to_i,
          title: node.at_css('manga_title, series_title').content,
          subtype: node.at_css('series_type')&.content,
          episode_count: node.at_css('series_episodes')&.content&.to_i,
          chapter_count: node.at_css('manga_chapters')&.content&.to_i
        }.compact
      end

      def status
        case node.at_css('my_status').content.gsub(/[\s-]+/, '').downcase
        when /ing\z/, '1' then :current
        when /\Aplan/, '6' then :planned
        when 'completed', '2' then :completed
        when 'onhold', '3' then :on_hold
        when 'dropped', '4' then :dropped
        end
      end

      def progress
        node.at_css('my_read_chapters, my_watched_episodes').content.to_i
      end

      def rating
        # 10-point scale to 20-point scale
        value = node.at_css('my_score').content
        value.to_i * 2 unless value == '0' || value.empty?
      end

      def reconsume_count
        node.at_css('my_times_read, my_times_watched').content.to_i
      end

      def notes
        node.css('my_comments, my_tags').map(&:content).reject(&:blank?)
            .join(';')
      end

      def volumes
        node.at_css('my_read_volumes')&.content&.to_i
      end

      def started_at
        DateTime.strptime(node.at_css('my_start_date'), '%F')
      rescue ArgumentError
        nil
      end

      def finished_at
        DateTime.strptime(node.at_css('my_finish_date'), '%F')
      rescue ArgumentError
        nil
      end

      def data
        %i[status progress rating reconsume_count notes started_at finished_at].map { |k|
          [k, send(k)]
        }.to_h
      end
    end
  end
end
