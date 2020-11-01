require 'rails_helper'

RSpec.describe PostPolicy do
  let(:owner) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:post) { build(:post, user: owner.resource_owner) }
  subject { described_class }

  permissions :update? do
    it('should allow owner') { should permit(owner, post) }
    it('should allow community mod') { should permit(community_mod, post) }
    it('should not allow other users') { should_not permit(other, post) }
    it('should not allow anons') { should_not permit(nil, post) }

    context 'when post is locked' do
      let(:post) { build(:post, :locked, user: owner.resource_owner) }

      it('should not allow regular user') { should_not permit(owner, post) }
      it('should allow community_mod') { should permit(community_mod, post) }
    end
  end

  permissions :update_lock? do
    let(:post) { build(:post, :locked, user: owner.resource_owner) }

    it('should allow community_mod') { should permit(community_mod, post) }
    it('should not allow owner') { should_not permit(owner, post) }
  end

  permissions :create? do
    it('should allow owner') { should permit(owner, post) }
    it('should not allow community mod') { should_not permit(community_mod, post) }
    it('should not allow random dude') { should_not permit(other, post) }
    it('should not allow anon') { should_not permit(nil, post) }
  end

  permissions :destroy? do
    it('should allow owner') { should permit(owner, post) }
    it('should allow community mod') { should permit(community_mod, post) }
    it('should now allow random dude') { should_not permit(other, post) }
    it('should not allow anon') { should_not permit(nil, post) }
  end
end
