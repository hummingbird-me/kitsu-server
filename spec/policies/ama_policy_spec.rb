require 'rails_helper'

RSpec.describe AMAPolicy do
  subject { described_class }

  let(:user) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:ama) { build(:ama, author: user.resource_owner) }

  permissions :create? do
    it('allows community mods') { is_expected.to permit(community_mod, ama) }
    it('does not allow user') { is_expected.not_to permit(user, ama) }
    it('does not allow other') { is_expected.not_to permit(other, ama) }
  end

  permissions :update?, :destroy? do
    it('allows user') { is_expected.to permit(user, ama) }
    it('does not allow other') { is_expected.not_to permit(other, ama) }
  end
end
