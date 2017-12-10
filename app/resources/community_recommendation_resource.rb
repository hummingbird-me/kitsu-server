class CommunityRecommendationResource < BaseResource
  has_one :community_recommendation_request
  has_one :media, polymorphic: true
  has_many :reasons

  filters :media_id, :media_type, :community_recommendation_request_id
end
