# frozen_string_literal: true

RSpec.describe Mutations::Favorite::Create do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let!(:media) { create(:manga) }

  query = <<~GRAPHQL
    mutation createFavoriteMutation($input: FavoriteCreateInput!){
      favorite {
        create(input: $input){
          errors {
            ...on Error{
              __typename
            }
          }
          result{
            id
            item {
              ...on Manga {
                id
              }
            }
          }
        }
      }
    }
  GRAPHQL

  context 'with a valid input' do
    it 'creates a new favorite entry' do
      expect {
        execute_query(query, input: {
          itemId: media.id,
          itemType: 'MANGA'
        })
      }.to change(Favorite, :count).by(1)
    end

    it 'returns the new favorite entry' do
      response = execute_query(query, input: {
        itemId: media.id,
        itemType: 'MANGA'
      })

      expect(response.dig('data', 'favorite', 'create', 'result')).to match(
        a_hash_including(
          'id' => an_instance_of(String),
          'item' => { 'id' => media.id.to_s }
        )
      )
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, input: {
        itemId: media.id,
        itemType: 'MANGA'
      })
      expect(response.dig('data', 'favorite', 'create', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthenticatedError')
      )
    end
  end

  context 'with a non existent media' do
    it 'returns a NotFoundError' do
      response = execute_query(query, input: {
        itemId: -1,
        itemType: 'MANGA'
      })
      expect(response.dig('data', 'favorite', 'create', 'errors')).to include(
        an_object_matching('__typename' => 'NotFoundError')
      )
    end
  end
end
