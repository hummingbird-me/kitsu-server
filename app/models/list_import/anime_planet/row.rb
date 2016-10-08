class ListImport
  class AnimePlanet
    class Row

      attr_reader :node

      def initialize(node)
        @node = node
      end

      def media_info
        {
          title: node.at_css('.tableTitle').text,
          show_type: node.at_css('.tableType')&.text,
          episode_count: node.at_css('.epsRating select.episodes option[selected]')&.text&.to_i
        }.compact
      end

      def status
        case node.at_css('.epsRating select.changeStatus option[selected]')&.text
        when 'Watched' then :completed
        when 'Watching' then :current
        when 'Want to Watch' then :planned
        when 'Stalled' then :on_hold
        when 'Dropped' then :dropped
        when "Won't Watch" then :what_the_fuck_goes_here
        end
      end


      def data
      %i[media_info].map do |k|
        [k, send(k)]
      end.to_h
    end

    end
  end
end
