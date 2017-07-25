class CommunityRecommendationFollowResource < BaseResource
  has_one :community_recommendation_request
  has_one :user

  filters :user_id, :community_recommendation_request_id
end
