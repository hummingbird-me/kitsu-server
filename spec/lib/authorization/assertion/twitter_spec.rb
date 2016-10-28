require 'rails_helper'

RSpec.describe Authorization::Assertion::TwitterAuth do
  let(:twitter_auth_response) do
    file_name = 'twitter_auth_response.json'
    open_file(file_name)
  end

  let(:twitter_followers_response) do
    file_name = 'twitter_followers_response.json'
    open_file(file_name)
  end

  let(:twitter_auth) do
    stub_request(
      :get,
      'https://api.twitter.com/1.1/account/verify_credentials.json'
    )
      .to_return(
        status: 200,
        body: twitter_auth_response,
        headers: {}
      )
    stub_request(
      :get,
      'https://api.twitter.com/1.1/account/verify_credentials.json?'\
      'skip_status=true'
    )
      .to_return(
        status: 200,
        body: twitter_auth_response,
        headers: {}
      )
    stub_request(
      :get,
      'https://api.twitter.com/1.1/friends/list.json?'\
      'cursor=-1&user_id=2244994945'
    )
      .to_return(
        status: 200,
        body: twitter_followers_response,
        headers: {}
      )
    Authorization::Assertion::TwitterAuth.new(
      'any token',
      'any token secret'
    )
  end

  describe '#user!' do
    let!(:user) { create :user, twitter_id: '2244994945' }

    subject { twitter_auth.user! }

    it 'should return user' do
      expect(subject).to eq(user)
    end
  end

  describe '#import_friends' do
    let!(:user) { create :user, twitter_id: '2244994945' }
    let!(:friend) { create :user, twitter_id: '2959764566' }

    before { twitter_auth.import_friends }

    subject { Follow.where(follower: user, followed: friend) }

    it 'follow should exist' do
      expect(subject).to exist
    end
  end
end
