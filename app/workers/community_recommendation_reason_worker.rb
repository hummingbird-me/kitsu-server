class CommunityRecommendationReasonWorker
  include Sidekiq::Worker

  def perform(post)
    community_recommendation.send_community_recommendation(post)
  end
end