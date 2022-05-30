require 'rails_helper'
RSpec.describe UploadPolicy do
  subject { described_class }

  let(:user) { token_for create(:user) }
  let(:community_mod) { token_for create(:user, permissions: %i[community_mod]) }
  let(:upload) { build(:upload, user: user.resource_owner) }
  let(:other) { build(:upload) }

  permissions :create? do
    it('allows users') { is_expected.to permit(user, upload) }
    it('does not allow anons') { is_expected.not_to permit(nil, upload) }
  end

  permissions :show? do
    it('allows users') { is_expected.to permit(user, upload) }
    it('allows anons') { is_expected.to permit(nil, upload) }
  end

  permissions :update? do
    it('does not allow anons') { is_expected.not_to permit(nil, upload) }
    it('allows for yourself') { is_expected.to permit(user, upload) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
  end

  permissions :destroy? do
    it('does not allow anons') { is_expected.not_to permit(nil, upload) }
    it('allows for yourself') { is_expected.to permit(user, upload) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
    it('allows community mods') { is_expected.to permit(community_mod, upload) }
  end
end
