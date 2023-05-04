# frozen_string_literal: true

RSpec.describe Mutations::MediaReaction::Delete do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let!(:reaction) { create(:media_reaction, user:) }

  query = <<~GRAPHQL
    mutation deleteMediaReaction($mediaReactionId: ID!) {
      mediaReaction {
        delete(input: {
          mediaReactionId: $mediaReactionId
        }) {
          errors {
            ...on Error {
              __typename
              path
              message
            }
          }
          result {
            id
          }
        }
      }
    }
  GRAPHQL

  context "with a reaction which doesn't exist" do
    it 'returns a NotFound error' do
      result = execute_query(query, mediaReactionId: -1)
      expect(result.dig('data', 'mediaReaction', 'delete', 'errors')).to include(
        a_hash_including('__typename' => 'NotFoundError')
      )
    end
  end

  context 'with a reaction which belongs to another user' do
    let!(:reaction) { create(:media_reaction) }

    it 'returns a NotAuthorized error' do
      result = execute_query(query, mediaReactionId: reaction.id)
      expect(result.dig('data', 'mediaReaction', 'delete', 'errors')).to include(
        a_hash_including('__typename' => 'NotAuthorizedError')
      )
    end
  end

  context 'with a reaction which belongs to the current user' do
    it 'delete the media reaction' do
      expect {
        execute_query(query, mediaReactionId: reaction.id)
      }.to change(MediaReaction, :count).by(-1)
    end

    it 'returns the media reaction that it deleted' do
      response = execute_query(query, mediaReactionId: reaction.id)

      expect(response.dig('data', 'mediaReaction', 'delete', 'result')).to match(
        a_hash_including(
          'id' => reaction.id.to_s
        )
      )
    end
  end
end
