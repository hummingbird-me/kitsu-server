class CommunityRecommendationReasonWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def perform(post, community_recommendation)
    community_recommendation.send_community_recommendation(post)
  end
end
