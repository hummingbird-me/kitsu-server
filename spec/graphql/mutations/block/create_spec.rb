# frozen_string_literal: true

RSpec.describe Mutations::Block::Create do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let!(:blocked_user) { create(:user) }

  query = <<~GRAPHQL
    mutation createBlockMutation($blockedId: ID!){
      block {
        create(input: {blockedId: $blockedId}){
          errors {
            ...on Error{
              __typename
            }
          }
          result{
            id
            user {
              id
            }
            blockedUser {
              id
            }
          }
        }
      }
    }
  GRAPHQL

  context 'with a valid user to block' do
    it 'creates a new block' do
      expect {
        execute_query(query, blockedId: blocked_user.id)
      }.to change(Block, :count).by(1)
    end

    it 'returns the new block' do
      response = execute_query(query, blockedId: blocked_user.id)
      expect(response.dig('data', 'block', 'create', 'result')).to match(
        a_hash_including(
          'id' => an_instance_of(String),
          'user' => { 'id' => user.id.to_s },
          'blockedUser' => { 'id' => blocked_user.id.to_s }
        )
      )
    end
  end

  context 'with a non existent user to block' do
    it 'returns a NotFoundError' do
      response = execute_query(query, blockedId: -1)
      expect(response.dig('data', 'block', 'create', 'errors')).to include(
        a_hash_including('__typename' => 'NotFoundError')
      )
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, blockedId: blocked_user.id)
      expect(response.dig('data', 'block', 'create', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthenticatedError')
      )
    end
  end
end
