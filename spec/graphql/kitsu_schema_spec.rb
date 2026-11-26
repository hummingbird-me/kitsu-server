# frozen_string_literal: true

require 'rails_helper'

# Guards graphql-batch and FancyLoader against graphql-ruby upgrades. If lazy resolution stops
# batching, responses stay correct and only the query count grows, so nothing else would notice.
RSpec.describe KitsuSchema do
  let(:user) { create(:user) }
  let(:context) { { token: token_for(user), user: } }
  let(:query) do
    <<~GRAPHQL
      query ($id: ID!) {
        findProfileById(id: $id) {
          posts(first: 20) {
            nodes {
              likes(first: 3) { totalCount nodes { name } }
              comments(first: 2) { totalCount nodes { content } }
            }
          }
        }
      }
    GRAPHQL
  end

  def create_posts(count)
    create_list(:post, count, user:).each do |post|
      create(:post_like, post:)
      create(:comment, post:)
    end
  end

  # @return [Array(Integer, Array<Hash>)] the number of SQL queries run and the posts returned
  def run_query
    queries = 0
    counter = ->(*, payload) { queries += 1 unless payload[:cached] || payload[:name] == 'SCHEMA' }
    result = ActiveSupport::Notifications.subscribed(counter, 'sql.active_record') do
      described_class.execute(query, variables: { id: user.id }, context:).to_h
    end
    expect(result['errors']).to be_nil
    [queries, result.dig('data', 'findProfileById', 'posts', 'nodes')]
  end

  it 'batches loads, so more posts do not mean more queries', :aggregate_failures do
    create_posts(2)
    run_query # warm up anything loaded once per process
    few, = run_query

    create_posts(4)
    many, posts = run_query

    one = include('totalCount' => 1)
    one_each = include('likes' => one, 'comments' => one)
    expect(posts).to have_attributes(size: 6).and all(one_each)
    expect(few).to be_positive
    expect(many).to eq(few)
  end
end
