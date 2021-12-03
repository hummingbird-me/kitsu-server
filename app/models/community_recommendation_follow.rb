class CommunityRecommendationFollow < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :community_recommendation_request, required: true

  scope :for_request, ->(request) { where(community_recommendation_request: request) }

  after_create do
    user.notifications.follow(community_recommendation_request.feed, scrollback: 0)
  end

  before_destroy do
    user.notifications.unfollow(community_recommendation_request.feed)
  end
end
