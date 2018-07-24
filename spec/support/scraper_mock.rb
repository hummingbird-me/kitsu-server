module ScraperMock
  attr_reader :scraped_urls

  def scrape_async(*urls)
    @scraped_urls ||= []
    @scraped_urls += urls
  end
end
