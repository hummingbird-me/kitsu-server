class HTMLFilters::EmbedFilter < HTMLPipeline::NodeFilter
  SELECTOR = Selma::Selector.new(match_element: 'a.autolink, .onebox a')

  def after_initialize
    result[:embeddable_links] = []
  end

  def selector
    SELECTOR
  end

  def handle_element(element)
    result[:embeddable_links] << element['href']
  end
end
