class HTMLFilters::KramdownFilter < HTML::Pipeline::TextFilter
  def initialize(text, context = nil, result = nil)
    super text, context, result
    @text = @text.delete("\r")
  end

  def call
    Kramdown::Document.new(@text, input: 'Markdown').to_html
  end
end
