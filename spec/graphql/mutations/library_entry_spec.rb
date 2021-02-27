# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'mutation libraryEntry' do
  let(:media) { create(:anime) }
  let(:user) { create(:user) }
  let(:token) { token_for(user) }
  let(:context) { { token: token, user: user } }

  it 'create' do
    query = <<~GRAPHQL
      mutation createLibraryEntry($userId: ID!, $mediaId: ID!) {
        libraryEntry {
          create(input: {
            userId: $userId,
            mediaType: ANIME,
            mediaId: $mediaId,
            status: COMPLETED,
          }) {
            errors {
              code
              message
              path
            }
            libraryEntry {
              status
              id
            }
          }
        }
      }
    GRAPHQL

    result = KitsuSchema.execute(query,
      variables: { userId: user.id, mediaId: media.id },
      context: context,
      operation_name: 'createLibraryEntry').dig('data', 'libraryEntry', 'create')
    expect(result['errors']).to be_nil
    expect(result.dig('libraryEntry', 'id')).to be_present
    expect(result.dig('libraryEntry', 'status')).to eq('COMPLETED')
  end

  it 'update' do
    entry = create(:library_entry, user: user, media: media, status: :planned)
    query = <<~GRAPHQL
      mutation updateLibraryEntry($entryId: ID!) {
        libraryEntry {
          update(input: {
            id: $entryId,
            status: COMPLETED,
          }) {
            errors {
              code
              message
              path
            }
            libraryEntry {
              status
              id
            }
          }
        }
      }
    GRAPHQL

    result = KitsuSchema.execute(query,
      variables: { entryId: entry.id },
      context: context,
      operation_name: 'updateLibraryEntry').dig('data', 'libraryEntry', 'update')
    expect(result['errors']).to be_nil
    expect(result.dig('libraryEntry', 'id')).to be_present
    expect(result.dig('libraryEntry', 'status')).to eq('COMPLETED')
  end

  it 'delete' do
    entry = create(:library_entry, user: user, media: media, status: :planned)
    query = <<~GRAPHQL
      mutation deleteLibraryEntry($entryId: ID!) {
        libraryEntry {
          delete(input: {
            id: $entryId,
          }) {
            errors {
              code
              message
              path
            }
            libraryEntry {
              id
            }
          }
        }
      }
    GRAPHQL

    result = KitsuSchema.execute(query,
      variables: { entryId: entry.id },
      context: context,
      operation_name: 'deleteLibraryEntry').dig('data', 'libraryEntry', 'delete')
    expect(result['errors']).to be_nil
    expect(result.dig('libraryEntry', 'id')).to be_present
  end
end
