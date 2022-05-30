require 'rails_helper'

RSpec.describe MediaAttributeVotePolicy do
  subject { described_class }

  let(:user) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:vote) { build(:media_attribute_vote, user: user.resource_owner) }

  permissions :update?, :create?, :destroy? do
    it('allows user') { is_expected.to permit(user, vote) }
    it('does not allow other') { is_expected.not_to permit(other, vote) }
  end
end
