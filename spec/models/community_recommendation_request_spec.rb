require 'rails_helper'

RSpec.describe CommunityRecommendationRequest, type: :model do
  subject { build(:community_recommendation_request) }

  it { is_expected.to have_many(:community_recommendations) }
  it { is_expected.to belong_to(:user).required }
end
