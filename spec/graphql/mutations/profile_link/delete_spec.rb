# frozen_string_literal: true

RSpec.describe Mutations::ProfileLink::Delete do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let!(:profile_link_site) { ProfileLinkSite.find(1) }
  let!(:profile_link) { create(:profile_link, user:, profile_link_site:) }

  query = <<~GRAPHQL
    mutation deleteProfileLink($profileLinkId: ID!) {
      profileLink {
        delete(input: {profileLinkId: $profileLinkId}) {
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
      result = execute_query(query, profileLinkId: -1)
      expect(result.dig('data', 'profileLink', 'delete', 'errors')).to match(
        a_hash_including('__typename' => 'NotFoundError')
      )
    end
  end

  context 'with a profile link which belongs to another user' do
    let(:profile_link) { create(:profile_link, profile_link_site:) }

    it 'returns a NotAuthorized error' do
      result = execute_query(query, profileLinkId: profile_link.id)
      expect(result.dig('data', 'profileLink', 'delete', 'errors')).to include(
        a_hash_including('__typename' => 'NotAuthorizedError')
      )
    end
  end

  context 'with a profile link that belongs to the current user' do
    it 'delete the profile link' do
      expect {
        execute_query(query, profileLinkId: profile_link.id)
      }.to change(ProfileLink, :count).by(-1)
    end

    it 'returns the profile link that got deleted' do
      response = execute_query(query, profileLinkId: profile_link.id)

      expect(response.dig('data', 'profileLink', 'delete', 'result')).to match(
        a_hash_including(
          'id' => profile_link.id.to_s
        )
      )
    end
  end
end
