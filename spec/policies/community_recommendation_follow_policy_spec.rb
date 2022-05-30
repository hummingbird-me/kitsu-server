require 'rails_helper'

RSpec.describe CommunityRecommendationFollowPolicy do
  subject { described_class }

  let(:user) { token_for create(:user) }
  let(:follow) { build(:community_recommendation_follow, user: user.resource_owner) }
  let(:other) { build(:community_recommendation_follow) }

  permissions :update? do
    it('does not allow users') { is_expected.not_to permit(user, follow) }
    it('does not allow anons') { is_expected.not_to permit(nil, follow) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
  end

  permissions :create? do
    it('allows for yourself') { is_expected.to permit(user, follow) }
    it('does not allow anons') { is_expected.not_to permit(nil, follow) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
  end

  permissions :destroy? do
    it('does not allow anons') { is_expected.not_to permit(nil, follow) }
    it('allows for yourself') { is_expected.to permit(user, follow) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
  end
end
