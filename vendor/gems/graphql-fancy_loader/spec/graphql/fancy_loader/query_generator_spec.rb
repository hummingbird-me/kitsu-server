# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphQL::FancyLoader::QueryGenerator do
  it 'should apply multiple sorts in the provided order' do
    query = described_class.new(
      model: Post,
      find_by: :id,
      first: 10,
      after: 10,
      sort: [{
        column: -> { Post.arel_table[:created_at] },
        direction: :asc
      }, {
        column: -> { Post.arel_table[:id] },
        direction: :desc
      }],
      keys: [50]
    ).query.to_sql

    expect(query).to match('ORDER BY "posts"."created_at" ASC, "posts"."id" DESC')
  end

  it 'should allow modifying the query AST using sort[:transform]' do
    query = described_class.new(
      model: Post,
      find_by: :id,
      first: 10,
      after: 10,
      sort: [{
        column: -> { Post.arel_table[:created_at] },
        transform: lambda { |ast, _context|
          users = User.arel_table
          posts = Post.arel_table

          condition = users[:id].eq(posts[:user_id])

          ast.join(users, Arel::Nodes::OuterJoin).on(condition)
        },
        direction: :asc
      }],
      keys: [50]
    ).query.to_sql

    expect(query).to match('LEFT OUTER JOIN "users" ON "users"."id"')
  end

  context 'with after:' do
    context 'and first:' do
      it 'should generate the correct WHERE clause' do
        query = described_class.new(
          model: Post,
          find_by: :id,
          first: 10,
          after: 10,
          sort: [{
            column: -> { Post.arel_table[:created_at] },
            direction: :asc
          }],
          keys: [50]
        ).query.to_sql

        expect(query).to match('WHERE subquery."row_number" > 10 AND subquery."row_number" <= 20')
      end

      it 'should load the correct records' do
        user = create(:user)
        posts = create_list(:post, 4, user: user).sort_by(&:id)

        results = described_class.new(
          model: Post,
          find_by: :user_id,
          first: 2,
          after: 2,
          sort: [{
            column: -> { Post.arel_table[:id] },
            direction: :asc
          }],
          keys: [user.id]
        ).query

        expect(results.to_a).to eq(posts[2..nil])
        expect(results.count).to eq(2)
      end
    end

    context 'and last:' do
      it 'should load the correct records' do
        user = create(:user)
        posts = create_list(:post, 4, user: user).sort_by(&:id)

        results = described_class.new(
          model: Post,
          find_by: :user_id,
          last: 1,
          after: 1,
          sort: [{
            column: -> { Post.arel_table[:id] },
            direction: :asc
          }],
          keys: [user.id]
        ).query

        expect(results.to_a).to eq([posts[-1]])
        expect(results.count).to eq(1)
      end
    end
  end

  context 'with before:' do
    context 'and first:' do
      it 'should load the correct records' do
        user = create(:user)
        posts = create_list(:post, 4, user: user).sort_by(&:id)

        results = described_class.new(
          model: Post,
          find_by: :user_id,
          first: 1,
          before: 3,
          sort: [{
            column: -> { Post.arel_table[:id] },
            direction: :asc
          }],
          keys: [user.id]
        ).query

        expect(results.to_a).to eq([posts[0]])
        expect(results.count).to eq(1)
      end
    end

    context 'and last:' do
      it 'should load the correct records' do
        user = create(:user)
        posts = create_list(:post, 4, user: user).sort_by(&:id)

        results = described_class.new(
          model: Post,
          find_by: :user_id,
          last: 2,
          before: 4,
          sort: [{
            column: -> { Post.arel_table[:id] },
            direction: :asc
          }],
          keys: [user.id]
        ).query

        expect(results.to_a).to eq(posts[1..2])
        expect(results.count).to eq(2)
      end
    end
  end

  context 'with before: and after:' do
    it 'should return an empty array if after > before' do
      user = create(:user)
      posts = create_list(:post, 4, user: user).sort_by(&:id)

      results = described_class.new(
        model: Post,
        find_by: :user_id,
        before: 1,
        after: 3,
        sort: [{
          column: -> { Post.arel_table[:id] },
          direction: :asc
        }],
        keys: [user.id]
      ).query

      expect(results.to_a).to be_empty
    end
  end

  context 'with first: and last:' do
    it 'should load a weird middle of the set' do
      user = create(:user)
      posts = create_list(:post, 4, user: user).sort_by(&:id)

      results = described_class.new(
        model: Post,
        find_by: :user_id,
        first: 3,
        last: 3,
        sort: [{
          column: -> { Post.arel_table[:id] },
          direction: :asc
        }],
        keys: [user.id]
      ).query

      expect(results.to_a).to eq(posts[1..2])
      expect(results.count).to eq(2)
    end
  end

  it 'should load with a filter when given a where:' do
    user = create(:user)
    posts = create_list(:post, 4, user: user).sort_by(&:id)

    results = described_class.new(
      model: Post,
      where: {
        title: posts.first.title
      },
      find_by: :user_id,
      first: 4,
      after: 0,
      sort: [{
        column: -> { Post.arel_table[:id] },
        direction: :asc
      }],
      keys: [user.id]
    ).query

    expect(results.to_sql).to match("\"posts\".\"title\" = '#{posts.first.title}'")
    expect(results.to_a).to eq([posts.first])
  end

  it 'should modify the query before being executed when given a modify_query:' do
    query = described_class.new(
      model: Post,
      find_by: :user_id,
      first: 10,
      after: 10,
      sort: [{
        column: -> { Post.arel_table[:created_at] },
        direction: :asc
      }, {
        column: -> { Post.arel_table[:id] },
        direction: :desc
      }],
      keys: [50],
      modify_query: proc { |q| q.project('I am the bone of my sword') }
    ).query.to_sql

    expect(query).to match('I am the bone of my sword')
  end
end
