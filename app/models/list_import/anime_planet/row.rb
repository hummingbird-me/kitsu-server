class ListImport
  class AnimePlanet
    class Row

      attr_reader :node

      def initialize(node)
        @node = node
      end

      def media_info
        {
          title: node.at_css('.tableTitle').text
        }
      end


      def data
      %i[media_info ].map do |k|
        [k, send(k)]
      end.to_h
    end

    end
  end
end
