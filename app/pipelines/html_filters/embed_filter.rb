class HTMLFilters::EmbedFilter
  attr_reader :doc, :result, :context

  def initialize(text, context = {}, result = {})
    @doc = text.is_a?(String) ? Nokogiri::HTML.fragment(text) : text
    @context = context
    @result = result
  end

  def call
    result[:embeddable_links] = doc.css('a.autolink, .onebox a').map { |a| a['href'] }
    doc
  end
end
