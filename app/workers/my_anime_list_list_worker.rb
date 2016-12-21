class MyAnimeListListWorker
  include Sidekiq::Worker

  def perform(linked_profile)
    kitsu_library.each do |row|
      MyAnimeListSyncWorker.perform_async(row, 'create/update')
    end
  end

  private

  def kitsu_library
    # will get all anime/manga library entries for that user
    @kitsu_library ||= User.find(linked_profile.user_id).library_entries.all
  end
end
