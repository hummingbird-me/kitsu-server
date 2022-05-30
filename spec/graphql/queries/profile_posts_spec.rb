# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'query loadProfilePosts' do
  let(:media) { create(:anime) }
  let(:user) { create(:user) }
  let(:token) { token_for(user) }
  let(:context) { { token: token, user: user } }

  it 'works' do
    query = <<~GRAPHQL
      fragment userFields on Profile {
        name
      }
      fragment commentFields on Comment {
        content
        author { ...userFields }
        likes(first: 3, sort: [
          { on: FOLLOWING, direction: DESCENDING },
          { on: CREATED_AT, direction: ASCENDING },
        ]) {
          totalCount
          nodes { ...userFields }
        }
      }

      query loadProfilePosts($id: ID!) {
        findProfileById(id: $id) {
          name
          posts(first: 10) {
            pageInfo {
              hasNextPage
              hasPreviousPage
              endCursor
              startCursor
            }
            edges {
              cursor
              node {
                content
                author { ...userFields }
                likes(first: 3, sort: [
                  { on: FOLLOWING, direction: DESCENDING },
                  { on: CREATED_AT, direction: ASCENDING }
                ]) {
                  totalCount
                  nodes { ...userFields }
                }
                comments(first: 2, sort: [
                  { on: CREATED_AT, direction: DESCENDING }
                ]) {
                  totalCount
                  nodes {
                    ...commentFields
                    replies(first: 1, sort: [
                      { on: CREATED_AT, direction: DESCENDING }
                    ]) {
                      totalCount
                      nodes { ...commentFields }
                    }
                  }
                }
              }
            }
          }
        }
      }
    GRAPHQL

    user = create(:user)
    post = create(:post, user: user)
    create_list(:post_like, 3, post: post)
    comments = create_list(:comment, 3, post: post)
    create_list(:comment_like, 3, comment: comments.first)
    create_list(:comment, 3, post: post, parent: comments.first)

    result = KitsuSchema.execute(query,
      variables: { id: user.id },
      context: context,
      operation_name: 'loadProfilePosts').to_h

    expect(result).to match_json_expression({
      data: {
        findProfileById: {
          name: user.name,
          posts: {
            pageInfo: {
              hasNextPage: false,
              hasPreviousPage: false,
              endCursor: String,
              startCursor: String
            },
            edges: [{
              cursor: String,
              node: {
                content: post.content,
                author: { name: user.name },
                likes: {
                  totalCount: 3,
                  nodes: [{
                    name: String
                  }]
                },
                comments: {
                  totalCount: 3,
                  nodes: [{
                    author: {
                      name: String
                    },
                    content: String,
                    likes: {
                      totalCount: Integer,
                      nodes: all(match_json_expression({
                        name: String
                      }))
                    }
                  }]
                }
              }
            }]
          }
        }
      }
    })
  end
end
