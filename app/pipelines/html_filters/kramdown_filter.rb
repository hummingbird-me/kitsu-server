class HTMLFilters::KramdownFilter < HTMLPipeline::ConvertFilter
  def call(text, context: {}, result: {})
    text = text.delete("\r")
    Kramdown::Document.new(text, input: 'Markdown').to_html
  end
end
