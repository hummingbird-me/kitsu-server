require 'rails_helper'

RSpec.describe MediaAttributeVotePolicy do
  let(:user) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:vote) { build(:media_attribute_vote, user: user.resource_owner) }
  subject { described_class }

  permissions :update?, :create?, :destroy? do
    it('should allow user') { should permit(user, vote) }
    it('should not allow other') { should_not permit(other, vote) }
  end
end
