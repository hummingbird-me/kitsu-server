class LibraryEntryLogRemovalWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    LibraryEntryLog.where('created_at <= ?', 1.week.ago).destroy_all
  end
end
