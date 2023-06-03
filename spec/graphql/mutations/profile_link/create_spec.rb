# frozen_string_literal: true

RSpec.describe Mutations::ProfileLink::Create do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  query = <<~GRAPHQL
    mutation createProfileLink($input: ProfileLinkCreateInput!) {
      profileLink {
        create(input: $input) {
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
    it 'creates a new profile link' do
      expect {
        execute_query(query, input: {
          profileLinkSite: 'GITHUB',
          url: 'https://github.com/hummingbird-me'
        })
      }.to change(ProfileLink, :count).by(1)
    end

    it 'returns the new profile link' do
      response = execute_query(query, input: {
        profileLinkSite: 'GITHUB',
        url: 'https://github.com/hummingbird-me'
      })

      expect(response.dig('data', 'profileLink', 'create', 'result')).to match(
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
      expect(response.dig('data', 'profileLink', 'create', 'errors')).to include(
        a_hash_including(
          '__typename' => 'ValidationError'
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
      expect(response.dig('data', 'profileLink', 'create', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthenticatedError')
      )
    end
  end
end
