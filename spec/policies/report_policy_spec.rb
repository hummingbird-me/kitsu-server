require 'rails_helper'

RSpec.describe ReportPolicy do
  subject { described_class }

  let(:user) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:report) { build(:report, user: user.resource_owner) }

  permissions :update? do
    it('does not allow anon') { is_expected.not_to permit(nil, report) }
    it('does not allow random users') { is_expected.not_to permit(other, report) }
    it('allows the author') { is_expected.to permit(user, report) }
    it('allows community mods') { is_expected.to permit(community_mod, report) }
  end

  permissions :create? do
    it('does not allow anon') { is_expected.not_to permit(nil, report) }
    it('allows users') { permit(user, report) }
  end

  permissions :destroy? do
    it('does not allow community mods') { is_expected.not_to permit(community_mod, report) }
    it('does not allow reporter') { is_expected.not_to permit(user, report) }
  end
end
