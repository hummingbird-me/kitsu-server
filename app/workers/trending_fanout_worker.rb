class TrendingFanoutWorker
  include Sidekiq::Worker

  def perform(namespace, half_life, user, id, weight)
    user = User.find(user)
    namespace = namespace.safe_constantize
    service = TrendingService.new(namespace, half_life: half_life, user: user)
    service.fanout_vote(id, weight)
  end
end
