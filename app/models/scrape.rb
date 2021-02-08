class Scrape < ApplicationRecord
  enum status: %i[queued running failed completed]
  belongs_to :parent, class_name: 'Scrape', optional: true
  belongs_to :original_ancestor, class_name: 'Scrape', optional: true
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
  rescue StandardError
    update(status: :failed)
    raise
  end

  def run_async
    ScraperWorker.perform_async(id)
  end

  after_commit :run_async, on: :create

  before_create do
    if parent
      self.original_ancestor_id = parent.original_ancestor_id || parent_id
      self.depth = parent.depth + 1
      self.max_depth = parent.max_depth
    end
  end
end
