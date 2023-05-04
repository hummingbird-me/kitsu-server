# frozen_string_literal: true

RSpec.describe Mutations::Account::ChangePassword do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let(:user) { create(:user, password: 'correct horse battery staple') }

  query = <<~GRAPHQL
    mutation changePassword($input: AccountChangePasswordInput!) {
      account {
        changePassword(input: $input) {
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

  context 'with the correct old password' do
    context 'with a great new password' do
      it 'updates the account password' do
        expect {
          execute_query(query, input: {
            oldPassword: 'correct horse battery staple',
            newPassword: 'this is a test'
          })
        }.to(change { user.reload.password_digest })
      end

      it 'returns the Account object' do
        result = execute_query(query, input: {
          oldPassword: 'correct horse battery staple',
          newPassword: 'this is a test'
        })
        expect(result.dig('data', 'account', 'changePassword', 'result')).to match(
          a_hash_including('id' => user.id.to_s)
        )
      end
    end
  end

  context 'when not logged in' do
    let(:user) { nil }

    it 'returns a NotAuthenticated error' do
      result = execute_query(query, input: {
        oldPassword: 'correct horse battery staple',
        newPassword: 'this is a test'
      })
      expect(result.dig('data', 'account', 'changePassword', 'errors')).to include(
        a_hash_including('__typename' => 'NotAuthenticatedError')
      )
    end
  end

  context 'with the incorrect current password' do
    it 'returns a NotAuthorized error' do
      result = execute_query(query, input: {
        oldPassword: 'incorrect password',
        newPassword: 'this is a test'
      })
      expect(result.dig('data', 'account', 'changePassword', 'errors')).to include(
        a_hash_including('__typename' => 'NotAuthorizedError')
      )
    end
  end
end
