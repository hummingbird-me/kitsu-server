# frozen_string_literal: true

RSpec.describe Mutations::Favorite::Delete do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let!(:media) { create(:anime) }
  let!(:favorite) { create(:favorite, item: media, user:) }

  query = <<~GRAPHQL
    mutation deleteFavoriteMutation($favoriteId: ID!){
      favorite {
        delete(input: {favoriteId: $favoriteId}){
          errors {
            ...on Error{
              __typename
            }
          }
          result{
            id
            item {
              ...on Anime {
                id
              }
            }
          }
        }
      }
    }
  GRAPHQL

  context 'with a valid favorite entry that belongs to the current user' do
    it 'delete the favorite entry' do
      expect {
        execute_query(query, favoriteId: favorite.id)
      }.to change(Favorite, :count).by(-1)
    end

    it 'returns the favorite entry that got deleted' do
      response = execute_query(query, favoriteId: favorite.id)
      expect(response.dig('data', 'favorite', 'delete', 'result')).to match(
        a_hash_including(
          'id' => favorite.id.to_s,
          'item' => { 'id' => media.id.to_s }
        )
      )
    end
  end

  context 'with a non existent favorite entry' do
    it 'returns a NotFound error' do
      result = execute_query(query, favoriteId: -1)
      expect(result.dig('data', 'favorite', 'delete', 'errors')).to match(
        a_hash_including('__typename' => 'NotFoundError')
      )
    end
  end

  context 'with a favorite entry which belongs to another user' do
    let(:favorite) { create(:favorite, item: media) }

    it 'returns a NotAuthorizedError' do
      response = execute_query(query, favoriteId: favorite.id)
      expect(response.dig('data', 'favorite', 'delete', 'errors')).to match(
        a_hash_including('__typename' => 'NotAuthorizedError')
      )
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, favoriteId: favorite.id)

      expect(response.dig('data', 'favorite', 'delete', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthenticatedError')
      )
    end
  end
end
