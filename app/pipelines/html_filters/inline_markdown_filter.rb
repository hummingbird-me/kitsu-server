class HTMLFilters::InlineMarkdownFilter < HTMLPipeline::ConvertFilter
  def call(text, context: {}, result: {})
    text = text.delete("\r")
    Kramdown::Document.new(text, input: 'InlineMarkdown').to_html
  end
end
