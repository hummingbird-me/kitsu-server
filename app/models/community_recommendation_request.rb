# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: community_recommendation_requests
#
#  id          :integer          not null, primary key
#  description :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null, indexed
#
# Indexes
#
#  index_community_recommendation_requests_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_0a581e110a  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class CommunityRecommendationRequest < ApplicationRecord
  include WithActivity

  belongs_to :user
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
