# frozen_string_literal: true

require 'rails_helper'

# Drives the JSON:API through the full Rack stack with a real OAuth token, so framework upgrades
# that change request parsing, content negotiation or serialization get caught.
RSpec.describe 'JSON:API' do
  let(:user) { create(:user) }
  let(:anime) { create(:anime) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id, scopes: 'public') }
  let(:auth) { { 'Authorization' => "Bearer #{token.token}" } }
  let(:media_type) { 'application/vnd.api+json' }
  let(:body) do
    {
      data: {
        type: 'libraryEntries',
        attributes: { status: 'current', progress: 1 },
        relationships: {
          user: { data: { type: 'users', id: user.id.to_s } },
          media: { data: { type: 'anime', id: anime.id.to_s } }
        }
      }
    }
  end

  def json
    JSON.parse(response.body)
  end

  it 'reads a resource' do
    get "/api/edge/anime/#{anime.id}", headers: { 'Accept' => media_type }

    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq(media_type)
    expect(json.dig('data', 'attributes', 'slug')).to eq(anime.slug)
    expect(json.dig('data', 'links', 'self')).to end_with("/api/edge/anime/#{anime.id}")
  end

  it 'creates, updates and deletes a resource' do
    post '/api/edge/library-entries', params: body.to_json,
      headers: auth.merge('Content-Type' => media_type)
    expect(response).to have_http_status(:created)
    id = json.dig('data', 'id')

    patch "/api/edge/library-entries/#{id}",
      params: { data: { id:, type: 'libraryEntries', attributes: { progress: 2 } } }.to_json,
      headers: auth.merge('Content-Type' => media_type)
    expect(response).to have_http_status(:ok)
    expect(json.dig('data', 'attributes', 'progress')).to eq(2)

    delete "/api/edge/library-entries/#{id}", headers: auth
    expect(response).to have_http_status(:no_content)
    expect(LibraryEntry.exists?(id)).to be(false)
  end

  # Android's OkHttp appends a charset to every request body
  it 'accepts a Content-Type with a charset parameter' do
    post '/api/edge/library-entries', params: body.to_json,
      headers: auth.merge('Content-Type' => "#{media_type}; charset=utf-8")

    expect(response).to have_http_status(:created)
  end

  it 'rejects writes with the wrong Content-Type' do
    post '/api/edge/library-entries', params: body.to_json,
      headers: auth.merge('Content-Type' => 'application/json')

    expect(response).to have_http_status(:unsupported_media_type)
  end

  it 'rejects unauthenticated writes' do
    post '/api/edge/library-entries', params: body.to_json,
      headers: { 'Content-Type' => media_type }

    expect(response).to have_http_status(:forbidden)
  end

  describe 'sorting library entries by media title' do
    it 'sorts by the requested title' do
      b = create(:library_entry, user:, media: create(:anime, titles: { en_jp: 'Bbb' }))
      a = create(:library_entry, user:, media: create(:anime, titles: { en_jp: 'Aaa' }))

      %w[anime.titles.en_jp anime.titles.canonical].each do |sort|
        get '/api/edge/library-entries', params: { filter: { user_id: user.id }, sort: }
        expect(response).to have_http_status(:ok)
        expect(json['data'].pluck('id')).to eq([a.id.to_s, b.id.to_s])
      end
    end

    # The title key is interpolated into the ORDER BY, so anything which isn't a locale must be
    # refused before it gets there
    ["anime.titles.en'", "anime.titles.canonical'", "anime.titles.en'||pg_sleep(1)||'en",
     'users.titles.en', 'anime.titles.xen_jpx'].each do |sort|
      it "rejects sort=#{sort}" do
        get '/api/edge/library-entries', params: { filter: { user_id: user.id }, sort: }

        expect(response).to have_http_status(:bad_request)
        expect(json.dig('errors', 0, 'title')).to eq('Invalid sort criteria')
      end
    end
  end

  describe 'site permissions' do
    let(:headers) { auth.merge('Content-Type' => media_type) }

    it 'cannot be granted to yourself' do
      patch "/api/edge/users/#{user.id}", headers:, params: {
        data: { id: user.id.to_s, type: 'users', attributes: { permissions: %w[admin] } }
      }.to_json

      expect(response).to have_http_status(:bad_request)
      expect(user.reload.permissions.admin?).to be(false)
    end

    it 'cannot be granted by a community mod' do
      mod = create(:user, permissions: %i[community_mod])
      mod_token = Doorkeeper::AccessToken.create!(resource_owner_id: mod.id, scopes: 'public')

      patch "/api/edge/users/#{user.id}",
        headers: headers.merge('Authorization' => "Bearer #{mod_token.token}"),
        params: {
          data: { id: user.id.to_s, type: 'users', attributes: { permissions: %w[admin] } }
        }.to_json

      expect(response).to have_http_status(:bad_request)
      expect(user.reload.permissions.admin?).to be(false)
    end

    it 'cannot be set when signing up' do
      post '/api/edge/users', headers: { 'Content-Type' => media_type }, params: {
        data: { type: 'users', attributes: {
          name: 'Mallory', email: 'mallory@example.com', password: 'hunter2hunter2',
          permissions: %w[admin]
        } }
      }.to_json

      expect(response).to have_http_status(:bad_request)
      expect(User.where(email: 'mallory@example.com')).not_to exist
    end
  end
end
