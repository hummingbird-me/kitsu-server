class Loaders::PostLikesLoader < FancyLoader
  from PostLike
  sort :following,
    transform: ->(ast) {
      follows = Follow.arel_table
      likes = PostLike.arel_table

      condition = follows[:followed_id].eq(likes[:user_id]).and(
        follows[:follower_id].eq(5554)
      )

      ast.join(follows, Arel::Nodes::OuterJoin).on(condition)
    },
    on: -> { Follow.arel_table[:id] }
  sort :created_at
end
