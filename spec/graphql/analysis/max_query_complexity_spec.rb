# frozen_string_literal: true

require 'rails_helper'
require 'graphql/analysis/max_query_complexity'

RSpec.describe Analysis::MaxQueryComplexity do
  let!(:user) { create(:user) }
  let(:schema) { KitsuSchema }
  let(:reduce_result) { GraphQL::Analysis::AST.analyze_query(query, [Analysis::MaxQueryComplexity]) }
  let(:reduce_multiplex_result) do
    GraphQL::Analysis::AST.analyze_multiplex(multiplex, [Analysis::MaxQueryComplexity])
  end
  let(:variables) { {} }
  let(:query) { GraphQL::Query.new(schema, query_string, variables: variables) }
  let(:multiplex) do
    GraphQL::Execution::Multiplex.new(
      schema: schema,
      queries: [query.dup, query.dup],
      context: {},
      max_complexity: 10
    )
  end

  describe 'queries with custom type' do
    let(:query_string) do
      %[|
        query findProfileById(id: 1) {
          id
          waifu {
            id
          }
        }
      |]
    end

    it 'sums the complexity for single custom type' do
      complexities = reduce_result.first

      expect(complexities).to eq(1)
    end

    context 'when nested context type' do
      let(:query_string) do
        %[|
          query findProfileById(id: 1) {
            id
            waifu {
              id
              media {
                id
              }
            }
          }
        |]
      end

      it 'sums the complexity for nested custom type' do
        complexities = reduce_result.first

        expect(complexities).to eq(2)
      end
    end
  end
end
