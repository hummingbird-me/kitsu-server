require 'rails_helper'

RSpec.describe CommunityRecommendationFollow, type: :model do
  subject { build(:community_recommendation_follow) }

  it { is_expected.to belong_to(:community_recommendation_request).required }
  it { is_expected.to belong_to(:user).required }
end
