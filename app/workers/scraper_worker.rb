class ScraperWorker
  include Sidekiq::Worker

  def perform(klass_name, url)
    klass_name.constantize.new(url).call
  end
end
