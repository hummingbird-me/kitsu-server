require 'rails_helper'

RSpec.describe PostLikePolicy do
  let(:user) { token_for build(:user) }
  let(:like) { build(:post_like, user: user.resource_owner) }
  let(:other) { build(:post_like) }
  subject { described_class }

  permissions :update? do
    it('should not allow users') { should_not permit(user, like) }
    it('should not allow anons') { should_not permit(nil, like) }
  end

  permissions :create?, :destroy? do
    it('should not allow anons') { should_not permit(nil, like) }
    it('should allow for yourself') { should permit(user, like) }
    it('should not allow for others') { should_not permit(user, other) }
  end
end
