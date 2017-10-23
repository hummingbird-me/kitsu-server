require 'rails_helper'
require 'authorization/assertion/facebook'

RSpec.describe Authorization::Assertion::Facebook do
  let(:facebook_response) do
    '{
      "id": "1659565134412042",
      "name": "Che Guevara",
      "email": "che@guevara.com",
      "first_name": "Che",
      "last_name": "Guevara",
      "gender": "male",
      "friends": {
        "data": [
          {
            "name": "Fidel Castro",
            "id": "10204220238175291"
          }
        ],
        "summary": {
          "total_count": 2
        }
      }
    }'
  end
  let(:facebook_auth) do
    stub_request(:get, %r{https://graph.facebook.com/v2.5/me.*})
      .to_return(status: 200, body: facebook_response, headers: {})
    Authorization::Assertion::Facebook.new('any token')
  end

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
