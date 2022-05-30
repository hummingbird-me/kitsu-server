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
        Mapping.lookup(key, media_info[:id]) || Mapping.guess(type, media_info)
      end

      def media_info
        @media_info ||= {
          id: node.at_css(<<-ID_NODES.squish).content.to_i,
            manga_mediadb_id, manga_mangadb_id, series_animedb_id, series_mangadb_id
          ID_NODES
          title: node.at_css('manga_title, series_title')&.content,
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
        value = node.at_css('my_score')&.content
        value.to_i * 2 unless value.blank? || value == '0'
      end

      def reconsume_count
        node.at_css('my_times_read, my_times_watched')&.content&.to_i
      end

      def notes
        comments = node.at_css('my_comments')&.content
        tags = node.at_css('my_tags')&.content
        return unless comments || tags
        tags.present? ? [comments, tags].join("\n=== MAL Tags ===\n") : comments
      end

      def volumes_owned
        node.at_css('my_read_volumes')&.content&.to_i
      end

      def started_at
        return unless node.at_css('my_start_date')
        DateTime.strptime(node.at_css('my_start_date')&.content, '%F')
      rescue ArgumentError
        nil
      end

      def finished_at
        return unless node.at_css('my_finish_date')
        DateTime.strptime(node.at_css('my_finish_date')&.content, '%F')
      rescue ArgumentError
        nil
      end

      def data
        %i[status progress rating reconsume_count notes volumes_owned
           started_at finished_at].index_with { |k| send(k) }.compact
      end
    end
  end
end
