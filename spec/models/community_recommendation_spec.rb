require 'rails_helper'

RSpec.describe CommunityRecommendation, type: :model do
  subject { build(:community_recommendation) }

  it { is_expected.to belong_to(:anime).optional }
  it { is_expected.to belong_to(:manga).optional }
  it { is_expected.to belong_to(:drama).optional }
  it { is_expected.to have_many(:reasons) }
  it { is_expected.to belong_to(:community_recommendation_request).required }
end
