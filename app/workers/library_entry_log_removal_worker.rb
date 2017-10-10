class LibraryEntryLogRemovalWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'later'

  def perform
    LibraryEntryLog.where('created_at <= ?', 1.month.ago).destroy_all
  end
end
