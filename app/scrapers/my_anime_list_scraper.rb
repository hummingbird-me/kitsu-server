# Base class for scrapers of MyAnimeList pages.  Provides a bunch of methods for common elements on
# MyAnimeList pages, such as the sidebar or h2-separated content.
class MyAnimeListScraper < Scraper
  BASE_URL = 'https://myanimelist.net/'.freeze

  private

  def page
    @page ||= http.get(@url)
  end

  # @return [String] the main header of a standard MAL page
  def header
    page.at_css('#contentWrapper h1').content.trim
  end

  # @return [Nokogiri::HTML::Node] The two-column container of a standard MAL page
  def content
    page.at_css('#content > table')
  end

  # @return [Nokogiri::HTML::Node] The sidebar of a standard MAL page
  def sidebar
    content.at_css('td:first-child .js-scrollfix-bottom')
  end

  # @return [Hash<String,Nokogiri::HTML::NodeSet] the sections in the MAL sidebar
  def sidebar_sections
    @sidebar_sections ||= parse_sections(sidebar.css('h2:first-child ~ *'))
  end

  # @return [Nokogiri::HTML::Node] The main container of a standard MAL page
  def main
    content.at_css('td:last-child .js-scrollfix-bottom-rel')
  end

  # @return [Hash<String,Nokogiri::HTML::NodeSet] the sections in the MAL sidebar
  def main_sections
    @main_sections ||= parse_sections(main.css('h2:first-child ~ *'))
  end

  # Parse a NodeSet where MAL has separate sections punctuated by <h2> headers
  # @param nodes [Nokogiri::HTML::NodeSet] the nodes to parse
  # @return [Hash<String,Nokogiri::HTML::NodeSet>] the nodes divided into sections
  def parse_sections(nodes)
    section = nil
    nodes.each_with_object(Hash.new { Nokogiri::HTML::NodeSet.new(page) }) do |node, out|
      if node.name == 'h2'
        section = node.content.trim
      else
        out[section] << node
      end
    end
  end

  def base_url
    BASE_URL
  end
end
