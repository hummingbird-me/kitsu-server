require 'rails_helper'

RSpec.describe Accounts::GrantSitePermission do
  let(:user) { create(:user, permissions: %i[admin]) }

  context 'with a valid permission' do
    it 'should return the user and their new permissions' do
      res = described_class.call(user: user, permission: :community_mod)
      expect(res.user.id).to eq(user.id)
      expect(res.permissions).to be_set(:community_mod)
      expect(res.permissions).to be_set(:admin)
    end
  end

  context 'with an invalid permission' do
    it 'should throw UnknownPermission error' do
      expect {
        described_class.call(user: user, permission: :poopy)
      }.to raise_exception(Accounts::GrantSitePermission::UnknownPermission)
    end
  end
end
