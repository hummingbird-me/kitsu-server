class HuluMappingWorker
  include Sidekiq::Worker

  def perform
    since = (Time.now - 24.hours).strftime('%F')
    HuluImport::HuluSeries.each do |series|
      series.episodes(since: since).each(&:video!) if series.media
    end
  end
end
