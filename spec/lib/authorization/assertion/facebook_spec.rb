require 'rails_helper'
require 'authorization/assertion/facebook'

RSpec.describe Authorization::Assertion::Facebook do
  before do
    stub_request(:get, %r{https://graph.facebook.com/v2.11/me\?.*})
      .to_return(body: fixture('auth/facebook/self.json'))
    stub_request(:get, %r{https://graph.facebook.com/v2.11/me/friends\?.*})
      .to_return(body: fixture('auth/facebook/friends.json'))
  end
  let(:facebook_auth) { Authorization::Assertion::Facebook.new('any token') }

  describe '#user!' do
    let!(:user) { create :user, facebook_id: '1659565134412042' }

    subject { facebook_auth.user! }

    it 'should return user' do
      expect(subject).to eq(user)
    end
  end

  describe '#auto_follows' do
    let!(:user) { create :user, facebook_id: '1659565134412042' }
    let!(:friend) { create :user, facebook_id: '10204220238175291' }

    before { facebook_auth.auto_follows }

    subject { Follow.where(follower: user, followed: friend) }

    it 'follow should exist' do
      expect(subject).to exist
    end
  end
end
