HTML::Pipeline.class_eval do
  def self.parse(document_or_html)
    document_or_html ||= ''
    if document_or_html.is_a?(String)
      Nokogiri::HTML.fragment(document_or_html)
    else
      document_or_html
    end
  end
end
