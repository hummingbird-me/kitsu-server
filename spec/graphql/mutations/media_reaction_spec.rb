# frozen_string_literal: true

RSpec.describe 'mutation mediaReaction' do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let(:media) { create(:anime) }
  let(:media_reaction) { create(:media_reaction) }

  describe '.like' do
    query = <<~GRAPHQL
      mutation likeMediaReaction($mediaReactionId: ID!) {
        mediaReaction {
          like(input: {
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
        expect(response.dig('data', 'mediaReaction', 'like', 'errors')).to include(
          an_object_matching('__typename' => 'NotFoundError')
        )
      end
    end

    context 'with a media reaction that has not been liked' do
      it 'creates a new media reaction vote' do
        expect {
          execute_query(query, mediaReactionId: media_reaction.id)
        }.to change(MediaReactionVote, :count).by(1)
      end

      it 'returns hasLiked=true' do
        response = execute_query(query, mediaReactionId: media_reaction.id)
        expect(response.dig('data', 'mediaReaction', 'like', 'result', 'hasLiked')).to be(true)
      end

      it 'does not return any errors' do
        response = execute_query(query, mediaReactionId: media_reaction.id)
        expect(response.dig('data', 'mediaReaction', 'like', 'errors')).to be_empty
      end
    end

    context 'with a media reaction that has already been liked' do
      before { MediaReactionVote.create!(user: user, media_reaction: media_reaction) }

      it 'does not create another media reaction vote' do
        expect {
          execute_query(query, mediaReactionId: media_reaction.id)
        }.not_to change(MediaReactionVote, :count)
      end

      it 'returns hasLiked=true' do
        response = execute_query(query, mediaReactionId: media_reaction.id)
        expect(response.dig('data', 'mediaReaction', 'like', 'result', 'hasLiked')).to be(true)
      end

      it 'does not return any errors' do
        response = execute_query(query, mediaReactionId: media_reaction.id)
        expect(response.dig('data', 'mediaReaction', 'like', 'errors')).to be_empty
      end
    end

    context 'when logged out' do
      let(:context) { {} }

      it 'returns a NotAuthenticated error' do
        response = execute_query(query, mediaReactionId: media_reaction.id)
        expect(response.dig('data', 'mediaReaction', 'like', 'errors')).to include(
          an_object_matching('__typename' => 'NotAuthenticatedError')
        )
      end
    end

    context 'when liking your own media reaction' do
      let(:user) { media_reaction.user }

      it 'returns a NotAuthorized error' do
        response = execute_query(query, mediaReactionId: media_reaction.id)
        expect(response.dig('data', 'mediaReaction', 'like', 'errors')).to include(
          an_object_matching('__typename' => 'NotAuthorizedError')
        )
      end
    end

    context 'when blocked by the author of the media reaction' do
      before { Block.create!(user_id: user.id, blocked_id: media_reaction.user.id) }

      it 'returns a NotAuthorized error' do
        response = execute_query(query, mediaReactionId: media_reaction.id)
        expect(response.dig('data', 'mediaReaction', 'like', 'errors')).to include(
          an_object_matching('__typename' => 'NotAuthorizedError')
        )
      end
    end
  end

  describe '.unlike' do
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
end
