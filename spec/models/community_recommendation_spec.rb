require 'rails_helper'

RSpec.describe CommunityRecommendation, type: :model do
  subject { build(:community_recommendation) }

  it { should belong_to(:anime).optional }
  it { should belong_to(:manga).optional }
  it { should belong_to(:drama).optional }
  it { should have_many(:reasons) }
  it { should belong_to(:community_recommendation_request).required }
end
