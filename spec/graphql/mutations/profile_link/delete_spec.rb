# frozen_string_literal: true

RSpec.describe Mutations::ProfileLink::Delete do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let!(:profile_link_site) { ProfileLinkSite.find(1) }
  let!(:profile_link) { create(:profile_link, user:, profile_link_site:) }

  query = <<~GRAPHQL
    mutation deleteProfileLink($profileLink: ProfileLinksSitesEnum!) {
      profileLink {
        delete(input: {profileLink: $profileLink}) {
          errors {
            ...on Error {
            __typename
            }
          }
          result {
            id
          }
        }
      }
    }
  GRAPHQL

  context 'with a profile link that does not exist' do
    it 'returns a NotFound error' do
      result = execute_query(query, profileLink: 'GITHUB')
      expect(result.dig('data', 'profileLink', 'delete', 'errors')).to match(
        a_hash_including('__typename' => 'NotFoundError')
      )
    end
  end

  context 'with a profile link that belongs to the current user' do
    it 'delete the profile link' do
      expect {
        execute_query(query, profileLink: 'TWITTER')
      }.to change(ProfileLink, :count).by(-1)
    end

    it 'returns the profile link that got deleted' do
      response = execute_query(query, profileLink: 'TWITTER')
      expect(response.dig('data', 'profileLink', 'delete', 'result')).to match(
        a_hash_including(
          'id' => profile_link.id.to_s
        )
      )
    end
  end
end
