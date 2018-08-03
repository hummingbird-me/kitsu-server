class ScraperWorker
  include Sidekiq::Worker

  def perform(scrape)
    Scrape.find(scrape).run
  end
end
