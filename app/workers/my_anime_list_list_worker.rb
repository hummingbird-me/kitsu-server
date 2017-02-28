class MyAnimeListListWorker
  include Sidekiq::Worker

  def perform(linked_account_id, user_id)
    kitsu_library(user_id).each do |library_entry|
      # create the logs here before the next worker
      library_entry_log = create_log(library_entry, linked_account_id)

      MyAnimeListSyncWorker.perform_async(
        library_entry_id: library_entry.id,
        # HACK: I am unable to determine the method
        # through the initial sync because I don't access their
        # mal list. For now everything will be a create action,
        # but at some point we can update to get the correct action.
        # Same issue with the LibraryEntryLog performed_action

        method: 'create',
        library_entry_log_id: library_entry_log.id
      )
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
