class ListImport
  class TaigaXML
    class Row
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def media
        Mapping.lookup('myanimelist/anime', mal_id)
      end

      def mal_id
        node.at_css('id').content.to_i
      end

      def status
        case node.at_css('status').content.gsub(/[\s-]+/, '').downcase
        when '1' then :current
        when '2' then :completed
        when '3' then :on_hold
        when '4' then :dropped
        when '5' then :planned
        end
      end

      def progress
        node.at_css('progress').content.to_i
      end

      def rating
        # 100-point scale to 20-point scale
        value = node.at_css('score').content
        value.to_i / 5 unless value == '0' || value.empty?
      end

      def notes
        comments = node.at_css('notes').content
        tags = node.at_css('tags').content
        tags.present? ? [comments, tags].join("\n=== MAL Tags ===\n") : comments
      end

      def started_at
        DateTime.strptime(node.at_css('date_start'), '%F')
      rescue ArgumentError
        nil
      end

      def finished_at
        DateTime.strptime(node.at_css('date_end'), '%F')
      rescue ArgumentError
        nil
      end

      def data
        %i[status progress rating notes started_at finished_at].index_with { |k| send(k) }
      end
    end
  end
end
