require 'rails_helper'

RSpec.describe MediaReactionPolicy do
  subject { described_class }

  let(:user) { token_for create(:user) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:anime) { build(:anime) }
  let(:media_reaction) do
    build(:media_reaction, user: user.resource_owner, anime: anime)
  end
  let(:other) { build(:media_reaction) }

  permissions :update? do
    it('does not allow anons') {
      is_expected.not_to permit(nil, media_reaction)
    }
  end

  permissions :create? do
    it('does not allow anons') {
      is_expected.not_to permit(nil, media_reaction)
    }

    it('does not allow for others') { is_expected.not_to permit(user, other) }

    it('allows for yourself') {
      is_expected.to permit(user, media_reaction)
    }
  end

  permissions :destroy? do
    it('allows community mod') { is_expected.to permit(community_mod, media_reaction) }

    it('allows for yourself') {
      is_expected.to permit(user, media_reaction)
    }
  end
end
