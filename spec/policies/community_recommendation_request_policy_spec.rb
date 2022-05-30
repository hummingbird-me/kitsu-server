require 'rails_helper'

RSpec.describe CommunityRecommendationRequestPolicy do
  subject { described_class }

  let(:user) { token_for create(:user) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:request) { build(:community_recommendation_request, user: user.resource_owner) }
  let(:other) { build(:community_recommendation_request) }

  permissions :update? do
    it('allows for yourself') { is_expected.to permit(user, request) }
    it('does not allow anons') { is_expected.not_to permit(nil, request) }
    it('allows for community mod') { is_expected.to permit(community_mod, request) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
  end

  permissions :create? do
    it('allows for yourself') { is_expected.to permit(user, request) }
    it('does not allow anons') { is_expected.not_to permit(nil, request) }
    it('does not allow community mod') { is_expected.not_to permit(community_mod, request) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
  end

  permissions :destroy? do
    it('does not allow anons') { is_expected.not_to permit(nil, request) }
    it('allows for yourself') { is_expected.to permit(user, request) }
    it('allows for community mod') { is_expected.to permit(community_mod, request) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
  end
end
