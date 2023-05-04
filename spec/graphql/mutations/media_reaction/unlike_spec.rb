# frozen_string_literal: true

RSpec.describe Mutations::MediaReaction::Unlike do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let(:media) { create(:anime) }
  let(:media_reaction) { create(:media_reaction) }

  query = <<~GRAPHQL
    mutation unlikeMediaReaction($mediaReactionId: ID!) {
      mediaReaction {
        unlike(input: {
          mediaReactionId: $mediaReactionId
        }) {
          errors {
            ...on Error {
              __typename
            }
          }
          result {
            id
            hasLiked
          }
        }
      }
    }
  GRAPHQL

  context 'with a media reaction which does not exist' do
    it 'returns a NotFound error' do
      response = execute_query(query, mediaReactionId: -1)
      expect(response.dig('data', 'mediaReaction', 'unlike', 'errors')).to include(
        an_object_matching('__typename' => 'NotFoundError')
      )
    end
  end

  context 'with a media reaction that has not been liked' do
    it 'returns hasLiked=false' do
      response = execute_query(query, mediaReactionId: media_reaction.id)
      expect(response.dig('data', 'mediaReaction', 'unlike', 'result', 'hasLiked')).to be(false)
    end

    it 'does not return any errors' do
      response = execute_query(query, mediaReactionId: media_reaction.id)
      expect(response.dig('data', 'mediaReaction', 'unlike', 'errors')).to be_empty
    end
  end

  context 'with a media reaction that has already been liked' do
    before { MediaReactionVote.create!(user: user, media_reaction: media_reaction) }

    it 'removes your media reaction vote' do
      expect {
        execute_query(query, mediaReactionId: media_reaction.id)
      }.to change(MediaReactionVote, :count).by(-1)
    end

    it 'returns hasLiked=false' do
      response = execute_query(query, mediaReactionId: media_reaction.id)
      expect(response.dig('data', 'mediaReaction', 'unlike', 'result', 'hasLiked')).to be(false)
    end

    it 'does not return any errors' do
      response = execute_query(query, mediaReactionId: media_reaction.id)
      expect(response.dig('data', 'mediaReaction', 'unlike', 'errors')).to be_empty
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, mediaReactionId: media_reaction.id)
      expect(response.dig('data', 'mediaReaction', 'unlike', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthenticatedError')
      )
    end
  end
end
