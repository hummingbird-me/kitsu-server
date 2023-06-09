# frozen_string_literal: true

require 'rails_helper'
require 'authorization/assertion/facebook'

RSpec.describe Authorization::Assertion::Facebook do
  before do
    stub_request(:get, %r{https://graph.facebook.com/v.*/me\?.*})
      .to_return(body: fixture('auth/facebook/self.json'))
    stub_request(:get, %r{https://graph.facebook.com/v.*/me/friends\?.*})
      .to_return(body: fixture('auth/facebook/friends.json'))
  end

  let(:facebook_auth) { Authorization::Assertion::Facebook.new('any token') }

  describe '#user!' do
    subject { facebook_auth.user! }

    let!(:user) { create :user, facebook_id: '1659565134412042' }

    it 'returns user' do
      expect(subject).to eq(user)
    end
  end

  describe '#auto_follows' do
    subject { Follow.where(follower: user, followed: friend) }

    let!(:user) { create :user, facebook_id: '1659565134412042' }
    let!(:friend) { create :user, facebook_id: '10204220238175291' }

    before { facebook_auth.auto_follows }

    it 'follow should exist' do
      expect(subject).to exist
    end
  end
end
