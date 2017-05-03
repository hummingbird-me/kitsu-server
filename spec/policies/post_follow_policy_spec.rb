require 'rails_helper'

RSpec.describe PostFollowPolicy do
  let(:user) { token_for build(:user) }
  let(:follow) { build(:post_follow, user: user.resource_owner) }
  let(:other) { build(:post_follow) }
  subject { described_class }

  permissions :update? do
    it('should not allow users') { should_not permit(user, follow) }
    it('should not allow anons') { should_not permit(nil, follow) }
  end

  permissions :create?, :destroy? do
    it('should not allow anons') { should_not permit(nil, follow) }
    it('should allow for yourself') { should permit(user, follow) }
    it('should not allow for others') { should_not permit(user, other) }
  end
end
