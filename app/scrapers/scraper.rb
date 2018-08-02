require 'faraday/parse_html'

# @abstract Subclass this, implement {#call} and {#match?}, and then register it in the {SCRAPERS}
#   array.
#
# Provides a basic building block for all other Scraper classes and a simple way of finding a
# subclass to handle a given URL.
class Scraper
  # No Scraper was found to match the URL provided
  class NoMatchError < StandardError
    def initialize(url)
      super("No matching scraper found registered to handle '#{url}'")
    end
  end
  class PageNotFound < StandardError; end

  # @param scrape [Scrape,String] the Scrape or URL to run
  def initialize(scrape)
    if scrape.respond_to?(:target_url)
      @scrape = scrape
      @url = scrape.target_url
    else
      @scrape = nil
      @url = scrape
    end
  end

  # Find a Scraper matching the URL provided and return an instance.
  #
  # @param scrape [Scrape,#target_url] the Scrape to run
  # @raise [NoMatchError] if no Scrapers matched the provided URL
  # @return [Scraper] an instance of a Scraper subclass for the URL
  def self.new(scrape)
    return super if self != Scraper
    SCRAPERS.each do |klass|
      scraper = klass.new(scrape)
      return scraper if scraper.match?
    end
    raise NoMatchError, scrape
  end

  # @abstract Override this method to return whether the class can scrape from the provided URL
  # @return [Boolean] whether the class can scrape from the URL
  def match?
    false
  end

  # @abstract Override this method to perform the task of actually scraping data from the URL.
  # @raise [NoMatchError] if it cannot actually scrape the URL
  def call
    raise NoMatchError unless match?
  end

  # Run the scraper instance in the background
  def call_async
    ScraperWorker.perform_async(self.class.name, @url)
  end

  def create_mapping(site, id, item)
    Mapping.where(external_site: site, external_id: id, item: item).first_or_create
  end

  def inspect
    "#<#{self.class.name} url: \"#{@url}\">"
  end

  private

  # Queue a scraper to run asynchronously
  def scrape_async(*urls)
    return if @scrape && @scrape&.max_depth == @scrape&.depth
    urls.map do |url|
      url = url.encode('ascii', undef: :replace, replace: '_')
      Scrape.where(
        original_ancestor_id: @scrape&.original_ancestor_id,
        target_url: url
      ).first_or_create(parent: @scrape)
    end
  end

  # A Faraday Connection for requests to be made against
  def http
    @http ||= Faraday.new(url: base_url) do |faraday|
      faraday.request :url_encoded
      faraday.response :follow_redirects
      faraday.use Faraday::ParseHtml
      faraday.adapter Faraday.default_adapter
    end
  end
end
