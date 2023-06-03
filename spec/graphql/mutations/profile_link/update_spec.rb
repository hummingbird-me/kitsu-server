# frozen_string_literal: true

RSpec.describe Mutations::ProfileLink::Update do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let!(:profile_link_site) { ProfileLinkSite.find(8) }
  let!(:profile_link) { create(:profile_link, user:, profile_link_site:) }

  query = <<~GRAPHQL
    mutation createProfileLink($input: ProfileLinkUpdateInput!) {
      profileLink {
        update(input: $input) {
          errors {
            ...on Error {
              __typename
            }
          }
          result {
            id
            url
            site {
              name
            }
          }
        }
      }
    }
  GRAPHQL

  context 'with a valid site and a valid url' do
    it 'updates the profile link' do
      response = execute_query(query, input: {
        profileLinkSite: 'GITHUB',
        url: 'https://github.com/hummingbird-me'
      })

      expect(response.dig('data', 'profileLink', 'update', 'result')).to match(
        a_hash_including(
          'id' => an_instance_of(String),
          'url' => 'https://github.com/hummingbird-me',
          'site' => { 'name' => 'GitHub' }
        )
      )
    end
  end

  context 'with an invalid url' do
    it 'returns a ValidationError' do
      response = execute_query(query, input: {
        profileLinkSite: 'GITHUB',
        url: 'https/github/hummingbird-me'
      })
      expect(response.dig('data', 'profileLink', 'update', 'errors')).to include(
        a_hash_including(
          '__typename' => 'ValidationError'
        )
      )
    end
  end

  context 'with a non existent profile link' do
    it 'returns a NotFoundError' do
      response = execute_query(query, input: {
        profileLinkSite: 'TWITTER',
        url: 'https://twitter.com/HeyKitsu'
      })
      expect(response.dig('data', 'profileLink', 'update', 'errors')).to include(
        a_hash_including(
          '__typename' => 'NotFoundError'
        )
      )
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, input: {
        profileLinkSite: 'GITHUB',
        url: 'https://github.com/hummingbird-me'
      })
      expect(response.dig('data', 'profileLink', 'update', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthenticatedError')
      )
    end
  end
end
