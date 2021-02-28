# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loaders::FancyLoader::QueryGenerator do
  it 'should apply multiple sorts in the provided order' do
    query = described_class.new(
      model: PostLike,
      find_by: :post_id,
      first: 10,
      after: 10,
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
      first: 10,
      after: 10,
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

  context 'with after:' do
    context 'and first:' do
      it 'should generate the correct WHERE clause' do
        query = described_class.new(
          model: PostLike,
          find_by: :post_id,
          first: 10,
          after: 10,
          sort: [{
            column: -> { PostLike.arel_table[:created_at] },
            direction: :asc
          }],
          token: nil,
          keys: [50]
        ).query.to_sql

        expect(query).to match('WHERE subquery."row_number" > 10 AND subquery."row_number" <= 20')
      end

      it 'should load the correct records' do
        post = create(:post)
        likes = create_list(:post_like, 4, post: post).sort_by(&:id)

        results = described_class.new(
          model: PostLike,
          find_by: :post_id,
          first: 2,
          after: 2,
          sort: [{
            column: -> { PostLike.arel_table[:id] },
            direction: :asc
          }],
          token: nil,
          keys: [post.id]
        ).query

        expect(results.to_a).to eq(likes[2..nil])
        expect(results.count).to eq(2)
      end
    end

    context 'and last:' do
      it 'should load the correct records' do
        post = create(:post)
        likes = create_list(:post_like, 4, post: post).sort_by(&:id)

        results = described_class.new(
          model: PostLike,
          find_by: :post_id,
          last: 1,
          after: 1,
          sort: [{
            column: -> { PostLike.arel_table[:id] },
            direction: :asc
          }],
          token: nil,
          keys: [post.id]
        ).query

        expect(results.to_a).to eq([likes[-1]])
        expect(results.count).to eq(1)
      end
    end
  end

  context 'with before:' do
    context 'and first:' do
      it 'should load the correct records' do
        post = create(:post)
        likes = create_list(:post_like, 4, post: post).sort_by(&:id)

        results = described_class.new(
          model: PostLike,
          find_by: :post_id,
          first: 1,
          before: 3,
          sort: [{
            column: -> { PostLike.arel_table[:id] },
            direction: :asc
          }],
          token: nil,
          keys: [post.id]
        ).query

        expect(results.to_a).to eq([likes[0]])
        expect(results.count).to eq(1)
      end
    end

    context 'and last:' do
      it 'should load the correct records' do
        post = create(:post)
        likes = create_list(:post_like, 4, post: post).sort_by(&:id)

        results = described_class.new(
          model: PostLike,
          find_by: :post_id,
          last: 2,
          before: 4,
          sort: [{
            column: -> { PostLike.arel_table[:id] },
            direction: :asc
          }],
          token: nil,
          keys: [post.id]
        ).query

        expect(results.to_a).to eq(likes[1..2])
        expect(results.count).to eq(2)
      end
    end
  end

  context 'with before: and after:' do
    it 'should return an empty array if after > before' do
      post = create(:post)
      create_list(:post_like, 4, post: post).sort_by(&:id)

      results = described_class.new(
        model: PostLike,
        find_by: :post_id,
        before: 1,
        after: 3,
        sort: [{
          column: -> { PostLike.arel_table[:id] },
          direction: :asc
        }],
        token: nil,
        keys: [post.id]
      ).query

      expect(results.to_a).to be_empty
    end
  end

  context 'with first: and last:' do
    it 'should load a weird middle of the set' do
      post = create(:post)
      likes = create_list(:post_like, 4, post: post).sort_by(&:id)

      results = described_class.new(
        model: PostLike,
        find_by: :post_id,
        first: 3,
        last: 3,
        sort: [{
          column: -> { PostLike.arel_table[:id] },
          direction: :asc
        }],
        token: nil,
        keys: [post.id]
      ).query

      expect(results.to_a).to eq(likes[1..2])
      expect(results.count).to eq(2)
    end
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
      first: 4,
      after: 0,
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
