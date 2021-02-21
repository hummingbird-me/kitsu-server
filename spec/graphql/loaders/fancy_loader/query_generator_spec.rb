# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loaders::FancyLoader::QueryGenerator do
  it 'should turn limit and offset into WHERE clause' do
    query = described_class.new(
      model: PostLike,
      find_by: :post_id,
      limit: 10,
      offset: 10,
      sort: [{
        column: -> { PostLike.arel_table[:created_at] },
        direction: :asc
      }],
      token: nil,
      keys: [50]
    ).query.to_sql

    expect(query).to match('WHERE subquery."row_number" > 10 AND subquery."row_number" <= 20')
  end

  it 'should apply multiple sorts in the provided order' do
    query = described_class.new(
      model: PostLike,
      find_by: :post_id,
      limit: 10,
      offset: 10,
      sort: [{
        column: -> { PostLike.arel_table[:created_at] },
        direction: :asc
      }, {
        column: -> { PostLike.arel_table[:id] },
        direction: :desc
      }],
      token: nil,
      keys: [50]
    ).query.to_sql

    expect(query).to match('ORDER BY "post_likes"."created_at" ASC, "post_likes"."id" DESC')
  end

  it 'should allow modifying the query AST using sort[:transform]' do
    query = described_class.new(
      model: PostLike,
      find_by: :post_id,
      limit: 10,
      offset: 10,
      sort: [{
        column: -> { Follow.arel_table[:created_at] },
        transform: ->(ast) {
          follows = Follow.arel_table
          likes = PostLike.arel_table

          condition = follows[:followed_id].eq(likes[:user_id])

          ast.join(follows, Arel::Nodes::OuterJoin).on(condition)
        },
        direction: :asc
      }],
      token: nil,
      keys: [50]
    ).query.to_sql

    expect(query).to match('LEFT OUTER JOIN "follows" ON "follows"."followed_id"')
  end

  it 'should load the correct number of records at the right offset' do
    post = create(:post)
    likes = create_list(:post_like, 4, post: post).sort_by(&:id)

    results = described_class.new(
      model: PostLike,
      find_by: :post_id,
      limit: 2,
      offset: 2,
      sort: [{
        column: -> { PostLike.arel_table[:id] },
        direction: :asc
      }],
      token: nil,
      keys: [post.id]
    ).query

    expect(results.first).to eq(likes[2])
    expect(results.count).to eq(2)
  end

  it 'should load with a filter when given a where:' do
    anime = create(:anime)
    episodes = create_list(:episode, 4, media: anime)

    results = described_class.new(
      model: Episode,
      where: {
        media_type: 'Anime'
      },
      find_by: :media_id,
      limit: 4,
      offset: 0,
      sort: [{
        column: -> { Episode.arel_table[:id] },
        direction: :asc
      }],
      token: nil,
      keys: [anime.id]
    ).query

    expect(results.to_sql).to match('"media_type" = \'Anime\'')
    expect(results.to_a).to eq(episodes)
  end
end
