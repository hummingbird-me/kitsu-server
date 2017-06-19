require_dependency 'user_engagement'

module UserEngagementNotification
  class UserEngagementMinuteWorker
    include Sidekiq::Worker

    def perform
      UserEngagement.send_mention_notification
      UserEngagement.send_new_profile_posts_notification
    end
  end
end
