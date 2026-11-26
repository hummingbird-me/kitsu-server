# frozen_string_literal: true

require 'rails_helper'

# We only enable the password and assertion grants (plus refresh), and callers come in three shapes:
#   - the Ember client sends no client credentials at all
#   - the React and mobile clients send a bare client_id for a public application
#   - third parties send a client_id and client_secret for a confidential application
# These drive the real endpoints for each shape, so a Doorkeeper upgrade can't quietly change them.
RSpec.describe 'OAuth', type: :request do
  let(:password) { 'correct horse battery' }
  let!(:user) { create(:user, password:, facebook_id: '1659565134412042') }
  let(:public_app) { create(:oauth_application, confidential: false) }
  let(:confidential_app) { create(:oauth_application) }
  let(:secret_credentials) { { client_id: confidential_app.uid, client_secret: confidential_app.secret } }

  before do
    stub_request(:get, %r{https://graph.facebook.com/v.*/me\?.*})
      .to_return(body: fixture('auth/facebook/self.json'))
  end

  def basic(app)
    { 'Authorization' => "Basic #{Base64.strict_encode64("#{app.uid}:#{app.secret}")}" }
  end

  def bearer(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  def request_token(params, headers = {})
    post '/api/oauth/token', params:, headers:
  end

  def password_grant(params = {}, headers = {})
    request_token({ grant_type: 'password', username: user.email, password: }.merge(params), headers)
  end

  def assertion_grant(params = {}, headers = {})
    request_token({ grant_type: 'assertion', provider: 'facebook', assertion: 'fb-token' }.merge(params), headers)
  end

  def refresh_grant(refresh_token, params = {})
    request_token({ grant_type: 'refresh_token', refresh_token: }.merge(params))
  end

  # Log in through the real endpoint and return the token response
  def log_in(params = {})
    password_grant(params)
    expect(response).to have_http_status(:ok)
    response.parsed_body
  end

  def issued_token
    Doorkeeper::AccessToken.find_by!(token: response.parsed_body['access_token'])
  end

  # The ids of the users the API thinks we are
  def signed_in_as(headers: {}, params: {})
    get '/api/edge/users', params: { filter: { self: true } }.merge(params), headers: headers
    JSON.parse(response.body)['data'].map { |u| u['id'].to_i }
  end

  def expect_oauth_error(status, error)
    expect(response).to have_http_status(status)
    expect(response.parsed_body['error']).to eq(error)
  end

  shared_examples 'a grant for each kind of client' do
    it 'issues a token without a client' do
      grant
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include('token_type' => 'Bearer', 'scope' => 'public')
      expect(response.parsed_body['refresh_token']).to be_present
      expect(issued_token).to have_attributes(resource_owner_id: user.id, application_id: nil)
    end

    it 'issues a token for a bare public client_id' do
      grant(client_id: public_app.uid)
      expect(response).to have_http_status(:ok)
      expect(issued_token).to have_attributes(resource_owner_id: user.id, application_id: public_app.id)
    end

    it 'issues a token for a confidential client in the body' do
      grant(secret_credentials)
      expect(response).to have_http_status(:ok)
      expect(issued_token.application_id).to eq(confidential_app.id)
    end

    it 'issues a token for a confidential client in a Basic header' do
      grant({}, basic(confidential_app))
      expect(response).to have_http_status(:ok)
      expect(issued_token.application_id).to eq(confidential_app.id)
    end

    it 'rejects a confidential client without its secret' do
      grant(client_id: confidential_app.uid)
      expect_oauth_error(:unauthorized, 'invalid_client')
    end

    it 'rejects an unknown client' do
      grant(client_id: 'nope')
      expect_oauth_error(:unauthorized, 'invalid_client')
    end

    it 'accepts client credentials sent in both the header and the body' do
      grant(secret_credentials, basic(confidential_app))
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'password grant' do
    def grant(...) = password_grant(...)

    it_behaves_like 'a grant for each kind of client'

    it 'rejects the wrong password' do
      request_token(grant_type: 'password', username: user.email, password: 'wrong')
      expect_oauth_error(:bad_request, 'invalid_grant')
    end

    it 'hands back the live token on a second login' do
      first = log_in
      expect(log_in['access_token']).to eq(first['access_token'])
    end

    it 'can ask for the everything scope' do
      password_grant(scope: 'everything')
      expect(response.parsed_body['scope']).to eq('everything')
    end
  end

  describe 'assertion grant' do
    def grant(...) = assertion_grant(...)

    it_behaves_like 'a grant for each kind of client'

    it 'rejects an unknown provider' do
      assertion_grant(provider: 'twitter')
      expect_oauth_error(:bad_request, 'invalid_grant')
    end

    it 'rejects an assertion Facebook refuses' do
      # Specs force every Flipper feature on; production has aozora off
      allow(Flipper).to receive(:enabled?).and_call_original
      allow(Flipper).to receive(:enabled?).with(:aozora).and_return(false)
      create(:user, facebook_id: nil)
      stub_request(:get, %r{https://graph.facebook.com/v.*/me\?.*}).to_return(
        status: 400,
        body: { error: { message: 'Invalid OAuth access token', type: 'OAuthException', code: 190 } }.to_json
      )

      assertion_grant(assertion: 'garbage')
      expect_oauth_error(:bad_request, 'invalid_grant')
    end
  end

  describe 'refresh grant' do
    it 'rotates a token issued without a client' do
      old = log_in
      refresh_grant(old['refresh_token'])

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['access_token']).not_to eq(old['access_token'])
      expect(signed_in_as(headers: bearer(response.parsed_body['access_token']))).to eq([user.id])
      expect(Doorkeeper::AccessToken.find_by!(token: old['access_token'])).to be_revoked
    end

    it 'refuses a refresh token that was already used' do
      old = log_in
      refresh_grant(old['refresh_token'])
      refresh_grant(old['refresh_token'])
      expect_oauth_error(:bad_request, 'invalid_grant')
    end

    it 'needs the client_id the token was issued to' do
      refresh_grant(log_in(client_id: public_app.uid)['refresh_token'])
      expect_oauth_error(:bad_request, 'invalid_grant')

      refresh_grant(log_in(client_id: public_app.uid)['refresh_token'], client_id: public_app.uid)
      expect(response).to have_http_status(:ok)
      expect(issued_token.application_id).to eq(public_app.id)
    end
  end

  describe 'using a token' do
    let(:token) { log_in['access_token'] }

    it 'accepts a Bearer header' do
      expect(signed_in_as(headers: bearer(token))).to eq([user.id])
    end

    it 'accepts an access_token parameter' do
      expect(signed_in_as(params: { access_token: token })).to eq([user.id])
    end

    it 'accepts a token sent in both the header and a parameter' do
      expect(signed_in_as(headers: bearer(token), params: { access_token: token })).to eq([user.id])
    end

    it 'rejects a revoked token' do
      Doorkeeper::AccessToken.find_by!(token:).revoke
      get '/api/edge/users', headers: bearer(token)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'revocation' do
    def revoke(token, params = {})
      post '/api/oauth/revoke', params: { token: }.merge(params)
    end

    it 'revokes a token issued without a client' do
      token = log_in['access_token']
      revoke(token, token_type_hint: 'access_token')

      expect(response).to have_http_status(:ok)
      expect(Doorkeeper::AccessToken.find_by!(token:)).to be_revoked
    end

    it 'revokes a public client token without its client_id' do
      token = log_in(client_id: public_app.uid)['access_token']
      revoke(token)

      expect(response).to have_http_status(:ok)
      expect(Doorkeeper::AccessToken.find_by!(token:)).to be_revoked
    end

    it 'needs the secret to revoke a confidential client token' do
      token = log_in(secret_credentials)['access_token']
      revoke(token)
      expect_oauth_error(:forbidden, 'unauthorized_client')
      expect(Doorkeeper::AccessToken.find_by!(token:)).not_to be_revoked
    end
  end

  describe 'application management' do
    let(:path) { "/api/oauth/applications/#{confidential_app.id}.json" }

    it 'is forbidden without a token' do
      get path
      expect(response).to have_http_status(:forbidden)
    end

    it 'does not let a normal user read, change or delete an application' do
      headers = bearer(log_in['access_token'])

      get(path, headers:)
      expect(response).to have_http_status(:forbidden)
      expect(response.body).not_to include(confidential_app.secret)

      put path, headers:, params: { doorkeeper_application: { redirect_uri: 'https://evil.example/cb' } }
      expect(response).to have_http_status(:forbidden)

      delete(path, headers:)
      expect(response).to have_http_status(:forbidden)
      expect(confidential_app.reload.redirect_uri).not_to eq('https://evil.example/cb')
    end

    it 'does not accept a revoked admin token' do
      user.update!(permissions: [:admin])
      token = log_in['access_token']
      Doorkeeper::AccessToken.find_by!(token:).revoke

      get path, headers: bearer(token)
      expect(response).to have_http_status(:forbidden)
    end

    it 'lets an admin in' do
      user.update!(permissions: [:admin])
      get path, headers: bearer(log_in['access_token'])
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['uid']).to eq(confidential_app.uid)
    end
  end
end
