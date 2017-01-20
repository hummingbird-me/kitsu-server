require_dependency 'kramdown/parser/inline_markdown'

module HTML
  class Pipeline
    class InlineMarkdownFilter < TextFilter
      def initialize(text, context = nil, result = nil)
        super text, context, result
        @text = @text.delete("\r")
      end

      def call
        Kramdown::Document.new(@text, input: 'InlineMarkdown').to_html
      end
    end
  end
end
