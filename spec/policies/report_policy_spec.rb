require 'rails_helper'

RSpec.describe ReportPolicy do
  let(:user) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:report) { build(:report, user: user.resource_owner) }
  subject { described_class }

  permissions :update? do
    it('should not allow anon') { should_not permit(nil, report) }
    it('should not allow random users') { should_not permit(other, report) }
    it('should allow the author') { should permit(user, report) }
    it('should allow community mods') { should permit(community_mod, report) }
  end

  permissions :create? do
    it('should not allow anon') { should_not permit(nil, report) }
    it('should allow users') { permit(user, report) }
  end

  permissions :destroy? do
    it('should not allow community mods') { should_not permit(community_mod, report) }
    it('should not allow reporter') { should_not permit(user, report) }
  end
end
