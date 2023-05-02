# frozen_string_literal: true

RSpec.describe Mutations::MediaReaction::Create do
  include_context 'with authenticated user'
  include_context 'with graphql helpers'

  let(:media) { create(:anime) }
  let!(:library_entry) { create(:library_entry, user:, media:) }

  query = <<~GRAPHQL
    mutation createMediaReaction($input: MediaReactionCreateInput!) {
      mediaReaction {
        create(input: $input) {
          errors {
            ...on Error {
              __typename
              path
              message
            }
          }
          result {
            id
            reaction
          }
        }
      }
    }
  GRAPHQL

  context "with a library entry which doesn't exist" do
    it 'returns a NotFound error' do
      result = execute_query(query, input: {
        libraryEntryId: -1,
        reaction: 'This library entry does not exist'
      })
      expect(result.dig('data', 'mediaReaction', 'create', 'errors')).to include(
        a_hash_including('__typename' => 'NotFoundError')
      )
    end
  end

  context 'with a library entry which belongs to another user' do
    it 'returns a NotFound error' do
      result = execute_query(query, input: {
        libraryEntryId: create(:library_entry).id,
        reaction: 'I am a major loser'
      })
      expect(result.dig('data', 'mediaReaction', 'create', 'errors')).to include(
        a_hash_including('__typename' => 'NotFoundError')
      )
    end
  end

  context 'with a valid reaction & library entry' do
    it 'creates a new media reaction' do
      expect {
        execute_query(query, input: {
          libraryEntryId: library_entry.id,
          reaction: 'This shit is FIIIIIRE'
        })
      }.to change(MediaReaction, :count).by(1)
    end

    it 'returns the new media reaction' do
      response = execute_query(query, input: {
        libraryEntryId: library_entry.id,
        reaction: 'THIS SHIT STINKS'
      })

      expect(response.dig('data', 'mediaReaction', 'create', 'result')).to match(
        a_hash_including(
          'reaction' => 'THIS SHIT STINKS',
          'id' => an_instance_of(String)
        )
      )
    end
  end

  context 'with a reaction too long' do
    it 'returns a ValidatonError' do
      result = execute_query(query, input: {
        libraryEntryId: library_entry.id,
        reaction: Faker::Lorem.paragraph_by_chars(number: 300)
      })
      expect(result.dig('data', 'mediaReaction', 'create', 'errors')).to include(
        a_hash_including(
          '__typename' => 'ValidationError',
          'path' => %w[input reaction]
        )
      )
    end
  end
end
