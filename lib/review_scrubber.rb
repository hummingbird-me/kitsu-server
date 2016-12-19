class ReviewScrubber
  attr_reader :review

  def initialize(review)
    @review = review
  end

  def scrub!
    output = div_to_p(review.content)
    output = Sanitize.fragment(output, Sanitize::Config::BASIC)
    output = br_to_p(output)
    review.update_attribute(:content_formatted, output)
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
