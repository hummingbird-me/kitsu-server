class MyAnimeListListWorker
  include Sidekiq::Worker

  def perform(linked_account_id, user_id)
    kitsu_library(user_id).each do |library_entry|
      begin
        log = create_log(library_entry, linked_account_id)
        sync = MyAnimeListSyncService.new(library_entry, 'create', log)
        sync.execute_method
      rescue Exception => exception
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
