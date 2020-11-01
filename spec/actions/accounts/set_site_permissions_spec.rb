require 'rails_helper'

RSpec.describe Accounts::SetSitePermissions do
  let(:user) { create(:user, permissions: %i[admin]) }

  context 'with valid permissions' do
    it 'should return the user and their new permissions' do
      res = described_class.call(user: user, permissions: [:community_mod])
      expect(res.user.id).to eq(user.id)
      expect(res.permissions).to be_set(:community_mod)
      expect(res.permissions).not_to be_set(:admin)
    end
  end

  context 'with an invalid permission' do
    it 'should throw UnknownPermissions error' do
      expect {
        described_class.call(user: user, permissions: %i[poopy community_mod])
      }.to raise_exception(Accounts::SetSitePermissions::UnknownPermissions)
      expect(user.reload.permissions).not_to be_set(:community_mod)
    end
  end
end
