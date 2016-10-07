class ListImport
  class AnimePlanet
    class Row

      attr_reader :page

      def initialize(page)
        @page = page
      end

      def total_pages
        page.css('.pagination li').map(&:content).map(&:to_i).max
      end


    end
  end
end
