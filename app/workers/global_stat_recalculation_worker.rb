class GlobalStatRecalculationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'later'

  def perform
    GlobalStat::AnimeAmountConsumed.recalculate!
    GlobalStat::MangaAmountConsumed.recalculate!
  end
end
