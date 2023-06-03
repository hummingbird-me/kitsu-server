# frozen_string_literal: true

RSpec.describe Mutations::Account::Update do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  query = <<~GRAPHQL
    mutation accountUpdateMutation($input: AccountUpdateInput!) {
      account {
        update(input: $input){
          errors {
            ...on Error {
              __typename
            }
          }
          result {
            id
            profile {
              id
              slug
            }
          }
        }
      }
    }
  GRAPHQL

  context 'with a valid input' do
    it 'updates the user account' do
      response = execute_query(query, input: {
        slug: 'newslug'
      })
      expect(response.dig('data', 'account', 'update', 'result', 'profile')).to match(
        a_hash_including(
          'id' => an_instance_of(String),
          'slug' => 'newslug'
        )
      )
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, input: {
        slug: 'newslug'
      })
      expect(response.dig('data', 'account', 'update', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthenticatedError')
      )
    end
  end
end
