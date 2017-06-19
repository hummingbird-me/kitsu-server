require_dependency 'user_engagement'

module UserEngagementNotification
  class UserEngagementHourWorker
    include Sidekiq::Worker

    def perform
      UserEngagement.send_post_replies_notification
    end
  end
end
