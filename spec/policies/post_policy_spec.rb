require 'rails_helper'

RSpec.describe PostPolicy do
  subject { described_class }

  let(:owner) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:post) { build(:post, user: owner.resource_owner) }

  permissions :update? do
    it('allows owner') { is_expected.to permit(owner, post) }
    it('allows community mod') { is_expected.to permit(community_mod, post) }
    it('does not allow other users') { is_expected.not_to permit(other, post) }
    it('does not allow anons') { is_expected.not_to permit(nil, post) }

    context 'when post is locked' do
      let(:post) { build(:post, :locked, user: owner.resource_owner) }

      it('does not allow regular user') { is_expected.not_to permit(owner, post) }
      it('allows community_mod') { is_expected.to permit(community_mod, post) }
    end
  end

  permissions :lock? do
    let(:post) { build(:post, :locked, user: owner.resource_owner) }

    it('allows community_mod') { is_expected.to permit(community_mod, post) }
    it('allows owner') { is_expected.to permit(owner, post) }
  end

  permissions :unlock? do
    let(:post) { build(:post, :locked, user: owner.resource_owner) }

    it('allows community_mod') { is_expected.to permit(community_mod, post) }
    it('does not allow owner') { is_expected.not_to permit(owner, post) }
  end

  permissions :create? do
    it('allows owner') { is_expected.to permit(owner, post) }
    it('does not allow community mod') { is_expected.not_to permit(community_mod, post) }
    it('does not allow random dude') { is_expected.not_to permit(other, post) }
    it('does not allow anon') { is_expected.not_to permit(nil, post) }
  end

  permissions :destroy? do
    it('allows owner') { is_expected.to permit(owner, post) }
    it('allows community mod') { is_expected.to permit(community_mod, post) }
    it('nows allow random dude') { is_expected.not_to permit(other, post) }
    it('does not allow anon') { is_expected.not_to permit(nil, post) }
  end
end
