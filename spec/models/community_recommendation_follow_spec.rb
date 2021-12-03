require 'rails_helper'

RSpec.describe CommunityRecommendationFollow, type: :model do
  subject { build(:community_recommendation_follow) }

  it { should belong_to(:community_recommendation_request).required }
  it { should belong_to(:user).required }
end
