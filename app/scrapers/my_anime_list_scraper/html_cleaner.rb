class MyAnimeListScraper
  # Clean up the HTML of a text block extracted from MyAnimeList, turning it into something we can
  # actually use.  This is a multi-step process implemented using DOM traversal instead of string
  # mangling, to avoid being tripped up by odd HTML formatting.
  class HtmlCleaner
    SOURCE_LINE = /^[\[\(](?:Written by |Source:)(.*)[\]\)]$/i
    EMPTY_TEXT = /No .* has been added to this .*/i

    def initialize(html)
      @html = html
    end

    def to_s
      return nil if EMPTY_TEXT =~ @html
      fragment = Nokogiri::HTML.fragment(@html)
      fragment = clean_spoilers(fragment)
      fragment = clean_paragraphs(fragment)
      fragment = clean_source(fragment)
      fragment = clean_info(fragment)
      fragment.to_html
    end

    private

    # Extract the freeform colon-separated data that prefaces some synopsis/description sections on
    # MAL into a top-level <info> node.  Inside the info node is a dictionary list of the data.
    #
    # @param doc [Nokogiri::Document] the document or fragment to clean the info in
    # @return [Nokogiri::Document] a document or fragment with the data hoisted and formatted
    def clean_info(doc)
      # Extract the info
      info = {}
      doc.css('p').each do |node|
        # The data is always colon-separated and has 3 or fewer words before the colon
        key, value = node.inner_html.split(':', 2)
        break unless value && key.strip.count(' ') < 3

        info[key.strip] = value.strip
        node.remove
      end

      # Build the data list
      fragment = Nokogiri::HTML.fragment('<data><dl></dl></data>')
      list = fragment.at_css('dl')
      info.each do |key, value|
        key_node = Nokogiri::XML::Node.new('dt', fragment)
        key_node.inner_html = key
        list.add_child(key_node)
        value_node = Nokogiri::XML::Node.new('dd', fragment)
        value_node.inner_html = value
        list.add_child(value_node)
      end

      # Inject it into the document
      if doc.first_element_child
        doc.first_element_child.previous = fragment
      else
        doc.add_child(fragment)
      end
      doc
    end

    # Paragraph-ify a nokogiri document, based on <br> tags.
    #
    # @param doc [Nokogiri::Document] the document or fragment to clean paragraphs of
    # @return [Nokogiri::HTML::Fragment] a fragment constructed from the paragraphs
    def clean_paragraphs(doc)
      out = Nokogiri::HTML.fragment('<p></p>')
      doc.children.each do |node|
        next out.add_child('<p></p>') if node.name == 'br'
        out.last_element_child.add_child(node)
      end
      out.css('p').each do |node|
        node.remove if node.content.blank?
      end
      out
    end

    # Replace MAL's weird spoiler HTML with a <spoiler> node
    #
    # @param doc [Nokogiri::Document] the document or fragment to fix spoilers in
    # @return [Nokogiri::Document] the document or fragment that was cleaned
    def clean_spoilers(doc)
      doc.css('.spoiler').each do |node|
        node.name = 'spoiler'
        node.remove_attribute('class')
        node.inner_html = node.css('.spoiler_content').inner_html
        node.css('input').remove
        node.css('br').remove
        node.xpath('descendant::comment()').remove
      end
      doc
    end

    # Replace MAL's inconsistent "Source" line with a <source> node
    #
    # @param doc [Nokogiri::Document] the document or fragment to fix the source in
    # @return [Nokogiri::Document] the document or fragment that was cleaned
    def clean_source(doc)
      source_node = doc.at_css("p:contains('Source:')")
      return doc unless SOURCE_LINE =~ source_node&.content
      source_node.name = 'source'
      source_node.content = SOURCE_LINE.match(source_node.content)[1]
      doc
    end
  end
end
