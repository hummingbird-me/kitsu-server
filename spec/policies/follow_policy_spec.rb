require 'rails_helper'

RSpec.describe FollowPolicy do
  let(:follower) { token_for build(:user) }
  let(:following) { build(:user) }
  let(:other) { token_for build(:user) }
  let(:follow) do
    build(:follow, follower: follower.resource_owner, followed: following)
  end
  subject { described_class }

  permissions :update?, :create?, :destroy? do
    it('should allow owner') { should permit(follower, follow) }
    it('should not allow others') { should_not permit(other, follow) }
    it('should not allow anons') { should_not permit(nil, follow) }
  end
end
