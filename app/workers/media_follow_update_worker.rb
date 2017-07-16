class MediaFollowUpdateWorker
  include Sidekiq::Worker

  def perform(library_entry_id, action, progress_was = nil, progress = nil)
    library_entry = LibraryEntry.find(library_entry_id)
    media_follow = MediaFollowService.new(library_entry.user, library_entry.media)
    media_follow.public_send(action, *[progress_was, progress].compact)
  end
end
