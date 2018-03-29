# Base class for scrapers of MyAnimeList pages.  Provides a bunch of methods for common elements on
# MyAnimeList pages, such as the sidebar or h2-separated content.
class MyAnimeListScraper < Scraper
  BASE_URL = 'https://myanimelist.net/'.freeze
  SOURCE_LINE = /^[\[\(](Written by .*|Source:.*)[\]\)]$/i
  EMPTY_TEXT = /No .* has been added to this .*/i

  private

  def page
    @page ||= http.get(@url).body
  end

  # @return [String] the main header of a standard MAL page
  def header
    page.at_css('#contentWrapper h1').content.strip
  end

  # @return [Nokogiri::XML::Node] The two-column container of a standard MAL page
  def content
    page.at_css('#content > table')
  end

  # @return [Nokogiri::XML::Node] The sidebar of a standard MAL page
  def sidebar
    content.at_css('td:first-child .js-scrollfix-bottom')
  end

  # @return [Hash<String,Nokogiri::XML::NodeSet] the sections in the MAL sidebar
  def sidebar_sections
    @sidebar_sections ||= parse_sections(sidebar.at_css('h2').parent.children)
  end

  # @return [Nokogiri::XML::Node] The main container of a standard MAL page
  def main
    content.at_css('td:last-child .js-scrollfix-bottom-rel')
  end

  # @return [Hash<String,Nokogiri::XML::NodeSet] the sections in the MAL sidebar
  def main_sections
    @main_sections ||= parse_sections(main.at_css('h2').parent.children)
  end

  # Parse a NodeSet where MAL has separate sections punctuated by <h2> headers
  # @param nodes [Nokogiri::HTML::NodeSet] the nodes to parse
  # @return [Hash<String,Nokogiri::XML::NodeSet>] the nodes divided into sections
  def parse_sections(nodes)
    # Keep track of what section we're in
    section = nil
    nodes.each_with_object({}) do |node, out|
      # Set up a fresh NodeSet for the current section if we haven't yet
      out[section] ||= Nokogiri::XML::NodeSet.new(page)
      # These nodes have a content but it are invisible
      node.css('script, style, iframe').each(&:remove)

      # Process the node
      if node.name == 'h2'
        section = node.xpath('./text()').map(&:content).join.strip
      else
        out[section] << node
      end
    end
  end

  # Clean a section of text to remove stray junk from MAL.
  # @param text [String] the dirty text from MAL
  # @return [String] the cleaned text
  def clean_text(text)
    lines = text.strip.each_line
    lines = lines.reject { |line| SOURCE_LINE =~ line }
    lines.join.strip.delete("\r")
  end

  def base_url
    BASE_URL
  end
end
