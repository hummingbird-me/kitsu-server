require 'rails_helper'

RSpec.describe FollowPolicy do
  let(:follower) { token_for create(:user) }
  let(:following) { token_for create(:user) }
  let(:other) { token_for build(:user) }
  let(:follow) do
    build(:follow, follower: follower.resource_owner, followed: following.resource_owner)
  end
  subject { described_class }

  permissions :update? do
    it('should allow the follower') { should permit(follower, follow) }
    it('should not allow the followed') { should_not permit(following, follow) }
    it('should not allow users') { should_not permit(other, follow) }
    it('should not allow anons') { should_not permit(nil, follow) }
  end
end
