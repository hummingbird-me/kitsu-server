require 'rails_helper'

RSpec.describe CommunityRecommendationRequestPolicy do
  let(:user) { token_for build(:user) }
  let(:admin) { token_for create(:user, :admin) }
  let(:request) { build(:community_recommendation_request, user: user.resource_owner) }
  let(:other) { build(:community_recommendation_request) }
  subject { described_class }

  permissions :update? do
    it('should allow for yourself') { should permit(user, request) }
    it('should not allow anons') { should_not permit(nil, request) }
    it('should allow for admin') { should permit(admin, request) }
    it('should not allow for others') { should_not permit(user, other) }
  end

  permissions :create? do
    it('should allow for yourself') { should permit(user, request) }
    it('should not allow anons') { should_not permit(nil, request) }
    it('should not for admin') { should_not permit(admin, request) }
    it('should not allow for others') { should_not permit(user, other) }
  end

  permissions :destroy? do
    it('should not allow anons') { should_not permit(nil, request) }
    it('should allow for yourself') { should permit(user, request) }
    it('should allow for admin') { should permit(admin, request) }
    it('should not allow for others') { should_not permit(user, other) }
  end
end
