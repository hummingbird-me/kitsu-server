class MyAnimeListListWorker
  include Sidekiq::Worker

  def perform(user_id)
    kitsu_library(user_id).each do |library_entry_ids|
      MyAnimeListSyncWorker.perform_async(library_entry_ids, 'create/update')
    end
  end

  private

  def kitsu_library(user_id)
    # will get all anime/manga library entries ids for that user
    @kitsu_library ||= User.find(user_id).library_entries.ids
  end
end
