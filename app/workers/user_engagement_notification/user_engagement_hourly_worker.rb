require_dependency 'user_engagement'

module UserEngagementNotification
  class UserEngagementHourlyWorker
    include Sidekiq::Worker

    def perform
      UserEngagement.send_post_likes_notification
      UserEngagement.send_reaction_upvotes_notification
    end
  end
end
