class HTMLFilters::UnembedFilter < HTMLPipeline::NodeFilter
  SELECTOR = Selma::Selector.new(match_element: 'iframe, img')

  def selector
    SELECTOR
  end

  def handle_element(element)
    href = to_href(element['src'])
    element.replace(%(<a href="#{href}" rel="nofollow">#{href}</a>), as: :html)
  end

  private

  def to_href(url)
    case url
    when %r{https?://.*\.youtube.com/embed/([^\?]+).*}
      "https://youtu.be/#{$1}"
    else url
    end
  end
end
