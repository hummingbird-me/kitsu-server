require 'rails_helper'

RSpec.describe CommentPolicy do
  let(:owner) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:comment) { build(:comment, user: owner.resource_owner) }
  subject { described_class }

  permissions :update? do
    it('should allow owner') { should permit(owner, comment) }
    it('should allow community mod') { should permit(community_mod, comment) }
    it('should not allow other users') { should_not permit(other, comment) }
    it('should not allow anons') { should_not permit(nil, comment) }

    context 'when post is locked' do
      let(:post) { build(:post, :locked, user: owner.resource_owner) }
      let(:comment) { build(:comment, user: admin.resource_owner, post: post) }

      it('should not allow a regular user') { should_not permit(other, comment) }
      it('should allow an admin') { should permit(admin, comment) }
    end
  end

  permissions :create? do
    it('should allow owner') { should permit(owner, comment) }
    it('should not allow community mod') { should_not permit(community_mod, comment) }
    it('should not allow random dude') { should_not permit(other, comment) }
    it('should not allow anon') { should_not permit(nil, comment) }

    context 'when post is locked' do
      let(:post) { build(:post, :locked, user: owner.resource_owner) }
      let(:admin_comment) { build(:comment, user: admin.resource_owner, post: post) }
      let(:owner_comment) { build(:comment, user: owner.resource_owner, post: post)  }

      it('should not allow regular owner') { should_not permit(owner, owner_comment) }
      it('should only allow admin owner') { should permit(admin, admin_comment) }
    end
  end

  permissions :destroy? do
    it('should allow owner') { should permit(owner, comment) }
    it('should allow community mod') { should permit(community_mod, comment) }
    it('should now allow random dude') { should_not permit(other, comment) }
    it('should not allow anon') { should_not permit(nil, comment) }
  end
end
