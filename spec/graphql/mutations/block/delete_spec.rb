# frozen_string_literal: true

RSpec.describe Mutations::Block::Delete do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let!(:blocked_user) { create(:user) }
  let!(:block) { create(:block, user:, blocked: blocked_user) }

  query = <<~GRAPHQL
    mutation deleteBlockMutation($blockId: ID!){
      block {
        delete(input: {blockId: $blockId}){
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

  context 'with a valid block that belongs to the current user' do
    it 'delete the block entry' do
      expect {
        execute_query(query, blockId: block.id)
      }.to change(Block, :count).by(-1)
    end

    it 'returns the block that got deleted' do
      response = execute_query(query, blockId: block.id)
      expect(response.dig('data', 'block', 'delete', 'result')).to match(
        a_hash_including(
          'id' => block.id.to_s,
          'user' => { 'id' => user.id.to_s },
          'blockedUser' => { 'id' => blocked_user.id.to_s }
        )
      )
    end
  end

  context 'with a non existent block' do
    it 'returns a NotFound error' do
      result = execute_query(query, blockId: -1)
      expect(result.dig('data', 'block', 'delete', 'errors')).to match(
        a_hash_including('__typename' => 'NotFoundError')
      )
    end
  end

  context 'with a favorite entry which belongs to another user' do
    let(:block) { create(:block) }

    it 'returns a NotAuthorizedError' do
      response = execute_query(query, blockId: block.id)
      expect(response.dig('data', 'block', 'delete', 'errors')).to match(
        a_hash_including('__typename' => 'NotAuthorizedError')
      )
    end
  end

  context 'when logged out' do
    let(:context) { {} }

    it 'returns a NotAuthenticated error' do
      response = execute_query(query, blockId: block.id)

      expect(response.dig('data', 'block', 'delete', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthenticatedError')
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
      response = execute_query(query, blockId: block.id)
      expect(response.dig('data', 'block', 'delete', 'errors')).to include(
        an_object_matching('__typename' => 'NotAuthorizedError')
      )
    end
  end
end
