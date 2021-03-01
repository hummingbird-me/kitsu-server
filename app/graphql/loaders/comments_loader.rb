class Loaders::CommentsLoader < Loaders::FancyLoader
  from Comment
  sort :following,
    transform: ->(ast) {
      follows = Follow.arel_table
      comment = Comment.arel_table

      condition = follows[:followed_id].eq(comment[:user_id]).and(
        follows[:follower_id].eq(User.current&.id)
      )

      ast.join(follows, Arel::Nodes::OuterJoin).on(condition)
    },
    on: -> { Follow.arel_table[:id] }
  sort :created_at
  sort :likes_count
end
