module Kramdown
  module Parser
    class InlineMarkdown < GFM
      def initialize(source, options)
        options = options.merge(hard_wrap: true)
        super(source, options)
        @block_parsers = %i[blank_line paragraph]
      end
    end
  end
end
