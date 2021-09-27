class Loaders::MediaReactionVotesLoader < Loaders::FancyLoader
  from MediaReactionVote

  sort :created_at
  sort :following,
    transform: ->(ast) {
      follows = Follow.arel_table
      votes = MediaReactionVote.arel_table

      condition = follows[:followed_id].eq(votes[:user_id]).and(
        follows[:follower_id].eq(User.current&.id)
      )

      ast.join(follows, Arel::Nodes::OuterJoin).on(condition)
    },
    on: -> { Follow.arel_table[:id] }
end
