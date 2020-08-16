class CommunityRecommendationRequestResource < BaseResource
  attributes :title, :description
  has_one :user
  has_many :community_recommendations

  filter :user_id

  def description
    _model.description['en']
  end
end
