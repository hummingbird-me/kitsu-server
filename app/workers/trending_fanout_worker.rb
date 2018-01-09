class TrendingFanoutWorker
  include Sidekiq::Worker
  # Since we don't currently display network trending on site, this is a very low priority.
  sidekiq_options queue: 'eventually'

  def perform(namespace, half_life, user, id, weight)
    user = User.find_by(id: user)
    return unless user
    namespace = namespace.safe_constantize
    service = TrendingService.new(namespace, half_life: half_life, user: user)
    service.fanout_vote(id, weight)
  end
end
