require 'rails_helper'

RSpec.describe AMAPolicy do
  let(:user) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:ama) { build(:ama, author: user.resource_owner) }
  subject { described_class }

  permissions :create? do
    it('should allow community mods') { should permit(community_mod, ama) }
    it('should not allow user') { should_not permit(user, ama) }
    it('should not allow other') { should_not permit(other, ama) }
  end

  permissions :update?, :destroy? do
    it('should allow user') { should permit(user, ama) }
    it('should not allow other') { should_not permit(other, ama) }
  end
end
