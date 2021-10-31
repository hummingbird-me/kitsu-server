class Loaders::CommentLikesLoader < GraphQL::FancyLoader
  from CommentLike
  sort :following,
    transform: ->(ast, context) {
      follows = Follow.arel_table
      likes = CommentLike.arel_table

      condition = follows[:followed_id].eq(likes[:user_id]).and(
        follows[:follower_id].eq(context[:token]&.id)
      )

      ast.join(follows, Arel::Nodes::OuterJoin).on(condition)
    },
    on: -> { Follow.arel_table[:id] }
  sort :created_at
end
