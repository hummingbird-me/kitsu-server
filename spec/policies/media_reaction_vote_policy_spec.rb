require 'rails_helper'

RSpec.describe MediaReactionVotePolicy do
  let(:owner) { token_for build(:user) }
  let(:other) { token_for build(:user, id: 2) }
  let(:media_reaction_vote) do
    build(:media_reaction_vote, user: owner.resource_owner)
  end
  subject { described_class }

  permissions :update? do
    it('should not allow users') {
      should_not permit(owner, media_reaction_vote)
    }
    it('should not allow anons') {
      should_not permit(nil, media_reaction_vote)
    }
  end

  permissions :create?, :destroy? do
    it('should allow owner') { should permit(owner, media_reaction_vote) }
    it('should not allow other') {
      should_not permit(other, media_reaction_vote)
    }
  end
end
