class MyAnimeListSyncWorker
  include Sidekiq::Worker

  # data is a hash
  def perform(data)
    # TODO: make a report per day for what is happening (syncing)
    case data['method']
    when 'delete'
      # will not exist in database
      # so passing in hash instead
      library_entry = data
    when 'create/update'
      # will still exist in database
      library_entry = LibraryEntry.find(data['library_entry_id'])
    end

    media = MyAnimeListSyncService.new(library_entry, data['method'])
    media.execute_method
  end
end
