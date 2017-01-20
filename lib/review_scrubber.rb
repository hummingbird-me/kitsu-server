class ReviewScrubber
  attr_reader :review

  def initialize(review)
    @review = review
  end

  def content_formatted
    output = div_to_p(review.content)
    output = Sanitize.fragment(output, Sanitize::Config::BASIC)
    output = br_to_p(output)
    output
  end

  def content
    html = content_formatted.gsub('rel="nofollow"', '')
    markdown = Kramdown::Document.new(html, input: 'html',
                                            html_to_native: true,
                                            parse_block_html: true,
                                            line_width: 150).to_kramdown
    markdown.gsub(/\\(["'])/, '\1')
  end

  def scrub!
    review.update_columns(
      content_formatted: content_formatted,
      content: content,
      legacy: false,
      updated_at: Time.now
    )
  end

  def br_to_p(src)
    src = '<p>' + src.gsub(/<br>\s*<br>/, '</p><p>') + '</p>'
    doc = Nokogiri::HTML.fragment src
    doc.traverse do |x|
      next x.remove if x.name == 'br' && x.previous.nil?
      next x.remove if x.name == 'br' && x.next.nil?
      next x.remove if x.name == 'br' && x.next.name == 'p' && x.previous.name == 'p'
      next x.remove if x.name == 'p' && x.content.blank?
    end
    doc.inner_html.gsub(/[\r\n\t]/, '')
  end

  def div_to_p(src)
    doc = Nokogiri::HTML.fragment src
    doc.search('div').each do |x|
      x.before('<br>')
      x.after('<br>')
    end
    doc.to_s
  end
end
