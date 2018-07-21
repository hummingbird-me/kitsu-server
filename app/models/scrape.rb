class Scrape < ApplicationRecord
  enum status: %i[queued running failed completed]
  belongs_to :parent, class_name: 'Scrape', required: false
  has_many :children, class_name: 'Scrape', foreign_key: 'parent_id', dependent: :destroy

  def scraper
    @scraper ||= Scraper.new(self)
  end

  def run
    update(scraper_name: scraper.class.name, status: :running)
    scraper.call
    update(status: :completed)
  rescue Scraper::NoMatchError
    update(scraper_name: 'None', status: :failed)
  end

  def run_async
    ScraperWorker.perform_async(id)
  end

  after_commit :run_async, on: :create
end
