# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analysis::MaxNodeLimit do
  let!(:user) { create(:user) }
  let(:schema) { KitsuSchema }
  let(:reduce_result) { GraphQL::Analysis::AST.analyze_query(query, [Analysis::MaxNodeLimit]) }
  let(:reduce_multiplex_result) do
    GraphQL::Analysis::AST.analyze_multiplex(multiplex, [Analysis::MaxNodeLimit])
  end
  let(:variables) { {} }
  let(:query) { GraphQL::Query.new(schema, query_string, variables: variables) }
  let(:multiplex) do
    GraphQL::Execution::Multiplex.new(
      schema: schema,
      queries: [query.dup, query.dup],
      context: {}
    )
  end

  describe 'queries with custom type' do
    let(:query_string) do
      %[
        query {
          findProfileById(id: 1) {
            id
            waifu {
              id
            }
          }
        }
      ]
    end

    it 'sums the complexity for single custom type' do
      complexities = reduce_result.first

      expect(complexities).to eq(2)
    end

    context 'when nested context type' do
      let(:query_string) do
        %[
          query {
            findProfileById(id: 1) {
              id
              waifu {
                id
                primaryMedia {
                  id
                }
              }
            }
          }
        ]
      end

      it 'sums the complexity for nested custom type' do
        complexities = reduce_result.first

        expect(complexities).to eq(3)
      end
    end
  end

  describe 'queries with connection' do
    context 'base case' do
      let(:query_string) do
        %[
          query($profileId: ID!, $followersLimit: Int) {
            findProfileById(id: $profileId) {
              id
              followers(first: $followersLimit) {
                nodes {
                  id
                }
              }
            }
          }
        ]
      end
      let(:variables) do
        {
          "profileId": 1,
          "followersLimit": 10
        }
      end

      it 'sums the complexity based on the limit provided' do
        complexities = reduce_result.first

        expect(complexities).to eq(11)
      end
    end

    context 'when deeply nested connections' do
      let(:query_string) do
        %[
          query(
            $profileId: ID!
            $followersLimit: Int
            $postsLimit: Int
            $commentsLimit: Int
          ) {
            findProfileById(id: $profileId) {
              id
              followers(first: $followersLimit) {
                nodes {
                  id
                  posts(first: $postsLimit) {
                    nodes {
                      id
                      comments(first: $commentsLimit) {
                        nodes {
                          id
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        ]
      end

      let(:variables) do
        {
          "profileId": 1,
          "followersLimit": 10,
          "postsLimit": 10,
          "commentsLimit": 10
        }
      end

      it 'properly calculates the total nodes' do
        complexities = reduce_result.first

        expect(complexities).to eq(1111)
      end
    end

    context 'when deeply nested connections with custom types' do
      let(:query_string) do
        %[
          query {
            findProfileById(id: 1) {
              id
              followers(first: 10) {
                nodes {
                  id
                  pinnedPost {
                    id
                  }
                  waifu {
                    id
                  }
                  posts(first: 10) {
                    nodes {
                      id
                    }
                  }
                }
              }
            }
          }
        ]
      end

      it 'properly calculates the total nodes' do
        complexities = reduce_result.first

        expect(complexities).to eq(131)
      end
    end

    context 'when limit is outside of range' do
      let(:query_string) do
        %[
          query {
            findProfileById(id: 1) {
              id
              followers(first: 101) {
                nodes {
                  id
                }
              }
            }
          }
        ]
      end

      it 'returns an error' do
        complexities = reduce_result.first

        expect(complexities.count).to eq(1)
        expect(complexities.first).to be_an_instance_of(GraphQL::AnalysisError)
      end
    end

    context 'when no limit is supplied' do
      let(:query_string) do
        %[
          query {
            findProfileById(id: 1) {
              id
              followers {
                nodes {
                  id
                }
              }
            }
          }
        ]
      end

      it 'returns an error' do
        complexities = reduce_result.first

        expect(complexities.count).to eq(1)
        expect(complexities.first).to be_an_instance_of(GraphQL::AnalysisError)
      end
    end
  end
end
