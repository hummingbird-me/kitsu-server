require 'rails_helper'

RSpec.describe MediaReactionVotePolicy do
  subject { described_class }

  let(:owner) { token_for create(:user) }
  let(:other) { token_for create(:user, id: 2) }
  let(:media_reaction_vote) do
    build(:media_reaction_vote, user: owner.resource_owner)
  end

  permissions :update? do
    it('does not allow users') {
      is_expected.not_to permit(owner, media_reaction_vote)
    }

    it('does not allow anons') {
      is_expected.not_to permit(nil, media_reaction_vote)
    }
  end

  permissions :create?, :destroy? do
    it('allows owner') { is_expected.to permit(owner, media_reaction_vote) }

    it('does not allow other') {
      is_expected.not_to permit(other, media_reaction_vote)
    }
  end
end
