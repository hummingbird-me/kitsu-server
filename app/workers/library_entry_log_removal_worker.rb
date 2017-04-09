class LibraryEntryLogRemovalWorker
  include Sidekiq::Worker

  def perform
    LibraryEntryLog.where('created_at <= ?', 1.week.ago).destroy_all
  end
end
