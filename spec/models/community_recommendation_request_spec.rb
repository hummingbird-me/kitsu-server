require 'rails_helper'

RSpec.describe CommunityRecommendationRequest, type: :model do
  subject { build(:community_recommendation_request) }

  it { should have_many(:community_recommendations) }
  it { should belong_to(:user).required }
end
