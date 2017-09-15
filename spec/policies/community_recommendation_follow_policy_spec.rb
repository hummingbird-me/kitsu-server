require 'rails_helper'

RSpec.describe CommunityRecommendationFollowPolicy do
  let(:user) { token_for build(:user) }
  let(:admin) { token_for create(:user, :admin) }
  let(:follow) { build(:community_recommendation_follow, user: user.resource_owner) }
  let(:other) { build(:community_recommendation_follow) }
  subject { described_class }

  permissions :update? do
    it('should not allow users') { should_not permit(user, follow) }
    it('should not allow anons') { should_not permit(nil, follow) }
    it('should not allow for others') { should_not permit(user, other) }
  end

  permissions :create? do
    it('should allow for yourself') { should permit(user, follow) }
    it('should not allow anons') { should_not permit(nil, follow) }
    it('should not for admin') { should_not permit(admin, follow) }
    it('should not allow for others') { should_not permit(user, other) }
  end

  permissions :destroy? do
    it('should not allow anons') { should_not permit(nil, follow) }
    it('should allow for yourself') { should permit(user, follow) }
    it('should allow for admin') { should permit(admin, follow) }
    it('should not allow for others') { should_not permit(user, other) }
    it('should not allow for others') { should_not permit(user, other) }
  end
end
