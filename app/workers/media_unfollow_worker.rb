class MediaUnfollowWorker
  include Sidekiq::Worker

  def perform
    EventUnfollowService.unfollow_next
  end
end
