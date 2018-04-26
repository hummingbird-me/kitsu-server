require 'faraday/parse_html'

# @abstract Subclass this, implement {#call} and {#match?}, and then register it in the {SCRAPERS}
#   array.
#
# Provides a basic building block for all other Scraper classes and a simple way of finding a
# subclass to handle a given URL.
class Scraper
  # No Scraper was found to match the URL provided
  class NoMatchError < StandardError; end

  # @param url [String] the URL to scrape
  def initialize(url)
    @url = url
  end

  # Find a Scraper matching the URL provided and return an instance.
  #
  # @param url [String] the URL to scrape
  # @raise [NoMatchError] if no Scrapers matched the provided URL
  # @return [Scraper] an instance of a Scraper subclass for the URL
  def self.for_url(url)
    SCRAPERS.each do |klass|
      scraper = klass.new(url)
      return scraper if scraper.match?
    end
    raise NoMatchError
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

  def inspect
    "#<#{self.class.name} url: \"#{@url}\">"
  end

  private

  # Queue a scraper to run asynchronously
  def scrape_async(url)
    Scraper.for_url(url).call_async
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
