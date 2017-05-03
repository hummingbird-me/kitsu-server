class MyAnimeListSyncWorker
  include Sidekiq::Worker
  # Try three times and then give up
  sidekiq_options retry: 3, queue: 'sync'

  # data is a hash
  def perform(data)
    case data['method']
    when 'delete'
      # will not exist in database
      # so passing in hash instead
      library_entry = data
    when 'create', 'update'
      # will still exist in database
      library_entry = LibraryEntry.find(data['library_entry_id'])
    end

    log = LibraryEntryLog.find(data['library_entry_log_id'])
    sync = MyAnimeListSyncService.new(
      library_entry, data['method'], log
    )
    sync.execute_method
  rescue ActiveRecord::RecordNotFound => exception
    Raven.capture_exception(exception)
  end
end
