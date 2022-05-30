require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  let(:user) { build(:user) }
  let(:user_token) { token_for(user) }
  let(:community_mod) { create(:user, permissions: %i[community_mod]) }
  let(:community_mod_token) { token_for(community_mod) }
  let(:other) { build(:user) }
  let(:other_token) { token_for(other) }

  permissions :create? do
    it('allows community mods') { is_expected.to permit(community_mod_token, other) }
    it('allows normal users') { is_expected.to permit(user_token, other) }
    it('allows anon') { is_expected.to permit(nil, other) }
  end

  permissions :update? do
    context 'for self' do
      it('allows normal users') { is_expected.to permit(user_token, user) }
      it('allows community mods') { is_expected.to permit(community_mod_token, community_mod) }
    end

    context 'for other' do
      it('does not allow normal users') { is_expected.not_to permit(user_token, other) }
      it('does not allow anons') { is_expected.not_to permit(nil, other) }
      it('allows community mods') { is_expected.to permit(community_mod_token, other) }
    end
  end

  permissions :destroy? do
    it('allows community mods') { is_expected.to permit(community_mod_token, other) }
    it('does not allow normal users') { is_expected.not_to permit(user_token, other) }
    it('does not allow anon') { is_expected.not_to permit(nil, other) }
  end
end
