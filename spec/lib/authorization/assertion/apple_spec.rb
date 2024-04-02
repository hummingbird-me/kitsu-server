# frozen_string_literal: true

require 'rails_helper'
require 'authorization/assertion/apple'

RSpec.describe Authorization::Assertion::Apple do
  let(:private_key) { OpenSSL::PKey::RSA.generate(2048) }
  let(:apple_auth) { Authorization::Assertion::Apple.new(signed_jwt, user_id) }
  let(:jwk) { JWT::JWK.new(private_key) }
  let(:jwt) do
    {
      iss: 'https://appleid.apple.com',
      aud: ENV['APPLE_CLIENT_ID'],
      iat: Time.now.to_i,
      exp: Time.now.to_i + 10.minutes,
      sub: 'xxx.yyy.zzz',
      email: 'kitsu-dev@privaterelay.appleid.com',
      is_private_email: 'true'
    }
  end
  let(:exported_private_key) { JWT::JWK::RSA.new(private_key).export.merge({ alg: 'RS256' }) }
  let(:apple_jwks) { [exported_private_key] }
  let(:signed_jwt) { JWT.encode(jwt, private_key, 'RS256', kid: jwk.kid) }
  let(:user_id) { 'xxx.yyy.zzz' }

  before do
    stub_request(:get, 'https://appleid.apple.com/auth/keys').to_return(
      body: {
        keys: apple_jwks
      }.to_json,
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    )
  end

  describe '#user!' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    subject(:test_subject) { apple_auth.user! }

    let!(:user) { create(:user, apple_id: 'xxx.yyy.zzz') }

    it 'returns the user' do
      expect(test_subject).to eq(user)
    end
  end
end
