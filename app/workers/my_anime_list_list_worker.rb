class MyAnimeListListWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'sync'

  def perform(linked_account_id, user_id)
    # Create the logs
    logs = kitsu_library(user_id).map do |le|
      [le, create_log(le, linked_account_id)]
    end
    # Generate the syncs
    syncs = logs.map do |(library_entry, log)|
      MyAnimeListSyncService.new(library_entry, 'create', log)
    end
    # Run the syncs
    syncs.each do |sync|
      # Suppress errors and keep going, we want to
      begin
        sync.execute_method
      rescue StandardError => exception
        # Queue a separate synv to retry
        MyAnimeListSyncWorker.perform_async(
          library_entry_id: sync.library_entry.id,
          method: sync.method,
          library_entry_log_id: sync.library_entry_log.id
        )
        Raven.capture_exception(exception)
      end
    end
  end

  private

  def kitsu_library(user_id)
    # will get all anime/manga library entries
    @kitsu_library ||= User.find(user_id).library_entries
  end

  def create_log(library_entry, linked_account_id)
    LibraryEntryLog.create(
      media_type: library_entry.media_type,
      media_id: library_entry.media_id,
      progress: library_entry.progress,
      rating: library_entry&.rating,
      reconsume_count: library_entry.reconsume_count,
      reconsuming: library_entry.reconsuming,
      status: library_entry.status,
      volumes_owned: library_entry.volumes_owned,
      # action_performed is either create, update, destroy
      # TODO: this is related to hack above
      action_performed: :create,
      linked_account_id: linked_account_id
    )
  end
end
