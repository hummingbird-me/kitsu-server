class CommunityRecommendationRequest < ApplicationRecord
  include WithActivity
  include DescriptionSanitation

  belongs_to :user, optional: false
  has_many :community_recommendations

  validates :description, presence: true
  validates :title, presence: true

  def feed
    @feed ||= CommunityRecommendationRequestFeed.new(id)
  end

  def stream_activity
    user.profile_feed.activities.new(
      title: title
    )
  end

  after_create do
    CommunityRecommendationFollow.create(
      user: user,
      community_recommendation_request: self
    )
  end
end
