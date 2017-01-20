module Trendable
  extend ActiveSupport::Concern

  def trending_service(user = nil)
    TrendingService.new(self.class, user: user)
  end

  def trending(limit = 5)
    trending_service.get(limit)
  end

  def trending_in_network(user, limit = 5)
    trending_service(user).get_network(limit)
  end

  def trending_vote(user, weight = 1.0)
    trending_service(user).vote(id, weight)
  end
end
