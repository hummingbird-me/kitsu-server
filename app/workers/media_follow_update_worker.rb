class MediaFollowUpdateWorker
  include Sidekiq::Worker
  sidekiq_options retry: 6, queue: 'soon'

  def perform(user_id, media_type, media_id, action, progress_was = nil, progress = nil) # rubocop:disable Metrics/ParameterLists
    user = User.find(user_id)
    media_class = media_type.safe_constantize
    media = media_class.find(media_id)
    media_follow = MediaFollowService.new(user, media)
    media_follow.public_send(action, *[progress_was, progress].compact)
  rescue ActiveRecord::RecordNotFound => ex
    Raven.capture_exception(ex)
  end

  def self.perform_for_entry(entry, action, progress_was = nil, progress = nil)
    perform_async(entry.user_id, entry.media_type, entry.media_id, action, progress_was, progress)
  end
end
