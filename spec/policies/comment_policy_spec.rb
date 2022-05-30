require 'rails_helper'

RSpec.describe CommentPolicy do
  subject { described_class }

  let(:owner) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:comment) { build(:comment, user: owner.resource_owner) }

  permissions :update? do
    it('allows owner') { is_expected.to permit(owner, comment) }
    it('allows community mod') { is_expected.to permit(community_mod, comment) }
    it('does not allow other users') { is_expected.not_to permit(other, comment) }
    it('does not allow anons') { is_expected.not_to permit(nil, comment) }

    context 'when post is locked' do
      let(:post) { build(:post, :locked, user: owner.resource_owner) }
      let(:comment) { build(:comment, user: community_mod.resource_owner, post: post) }

      it('does not allow a regular user') { is_expected.not_to permit(other, comment) }
      it('allows a community_mod') { is_expected.to permit(community_mod, comment) }
    end
  end

  permissions :create? do
    it('allows owner') { is_expected.to permit(owner, comment) }
    it('does not allow community mod') { is_expected.not_to permit(community_mod, comment) }
    it('does not allow random dude') { is_expected.not_to permit(other, comment) }
    it('does not allow anon') { is_expected.not_to permit(nil, comment) }

    context 'when post is locked' do
      let(:post) { build(:post, :locked, user: owner.resource_owner) }
      let(:community_mod_comment) do
        build(:comment, user: community_mod.resource_owner, post: post)
      end
      let(:owner_comment) { build(:comment, user: owner.resource_owner, post: post) }

      it('does not allow regular owner') { is_expected.not_to permit(owner, owner_comment) }

      it('onlies allow community_mod') {
        is_expected.to permit(community_mod, community_mod_comment)
      }
    end
  end

  permissions :destroy? do
    it('allows owner') { is_expected.to permit(owner, comment) }
    it('allows community mod') { is_expected.to permit(community_mod, comment) }
    it('nows allow random dude') { is_expected.not_to permit(other, comment) }
    it('does not allow anon') { is_expected.not_to permit(nil, comment) }
  end
end
