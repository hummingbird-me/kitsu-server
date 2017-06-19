require_dependency 'user_engagement'

module UserEngagementNotification
  class UserEngagementDailyWorker
    include Sidekiq::Worker

    def perform
      UserEngagement.send_inactive_notification
    end
  end
end
