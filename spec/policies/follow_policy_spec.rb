require 'rails_helper'

RSpec.describe FollowPolicy do
  subject { described_class }

  let(:follower) { token_for create(:user) }
  let(:following) { token_for create(:user) }
  let(:other) { token_for create(:user) }
  let(:banned_user) { token_for create(:user, :banned) }
  let(:follow) do
    build(:follow, follower: follower.resource_owner, followed: following.resource_owner)
  end
  let(:banned_follow) do
    build(:follow, follower: banned_user.resource_owner, followed: following.resource_owner)
  end

  permissions :update? do
    it('allows the follower') { is_expected.to permit(follower, follow) }
    it('does not allow the followed') { is_expected.not_to permit(following, follow) }
    it('does not allow users') { is_expected.not_to permit(other, follow) }
    it('does not allow anons') { is_expected.not_to permit(nil, follow) }
    it('does not allow banned users') { is_expected.not_to permit(banned_user, banned_follow) }
  end
end
