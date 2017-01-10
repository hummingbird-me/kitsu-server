class MyAnimeListListWorker
  include Sidekiq::Worker

  def perform(user_id)
    kitsu_library(user_id).each do |row|
      MyAnimeListSyncWorker.perform_async(row, 'create/update')
    end
  end

  private

  def kitsu_library(user_id)
    # will get all anime/manga library entries for that user
    @kitsu_library ||= User.find(user_id).library_entries.all
  end
end
