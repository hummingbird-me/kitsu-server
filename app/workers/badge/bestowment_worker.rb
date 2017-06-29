class Badge
  class BestowmentWorker
    include Sidekiq::Worker

    def perform(badge, user)
      badge = badge.safe_constantize
      user = User.find(user)
      Badge::BestowmentService.new(badge, user).run!
    end
  end
end
