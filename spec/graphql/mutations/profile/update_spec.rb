# frozen_string_literal: true

RSpec.describe Mutations::Profile::Update do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let(:mod) { create(:user, permissions: %i[community_mod]) }

  query = <<~GRAPHQL
    mutation profileUpdateMutation($input: ProfileUpdateInput!) {
      profile {
        update(input: $input){
          errors {
            ...on Error {
              __typename
            }
          }
          result {
            id
            gender
          }
        }
      }
    }
  GRAPHQL

  context 'with a valid input' do
    it 'updates the user profile' do
      response = execute_query(query, input: {
        gender: 'not specified'
      })
      expect(response.dig('data', 'profile', 'update', 'result')).to match(
        a_hash_including(
          'gender' => 'not specified'
        )
      )
    end
  end

  context 'when a mod tries to edit another user profile with a valid input' do
    let(:context) { { token: token_for(mod), user: mod } }

    it 'checks if the mod has the permissions' do
      expect(mod.permissions).to match(%i[community_mod])
    end

    it 'updates the other user profile' do
      response = execute_query(query, input: {
        id: user.id,
        gender: 'not specified'
      })
      expect(response.dig('data', 'profile', 'update', 'result')).to match(
        a_hash_including(
          'id' => an_instance_of(String),
          'gender' => 'not specified'
        )
      )
    end
  end

  context 'with a non existent user' do
    it 'returns a NotFound error' do
      response = execute_query(query, input: {
        id: -1,
        gender: 'not specified'
      })
      expect(response.dig('data', 'profile', 'update', 'errors')).to include(
        an_object_matching('__typename' => 'NotFoundError')
      )
    end
  end

  context 'when a non-mod user tries to edit another user with a valid input' do
    let(:non_mod) { create(:user, permissions: %i[]) }
    let(:context) { { token: token_for(non_mod), user: non_mod } }

    it 'checks if the user does not have permissions' do
      expect(non_mod.permissions).not_to match(%i[community_mod])
    end

    it 'returns a NotAuthorized error' do
      response = execute_query(query, input: {
        id: user.id,
        gender: 'not specified'
      })
      expect(response.dig('data', 'profile', 'update', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthorizedError')
      )
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, input: {
        gender: 'not specified'
      })
      expect(response.dig('data', 'profile', 'update', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthenticatedError')
      )
    end
  end
end
