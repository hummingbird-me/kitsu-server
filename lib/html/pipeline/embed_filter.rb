module HTML
  class Pipeline
    class EmbedFilter < HTML::Pipeline::Filter
      def call
        first_link = doc.at_css('a.autolink')
        result[:embed] = EmbedService.new(first_link['href']).as_json
        result[:embeddable_links] = doc.css('a.autolink').map { |a| a['href'] }
        doc
      end
    end
  end
end
