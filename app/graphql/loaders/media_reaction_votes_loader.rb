class Loaders::MediaReactionVotesLoader < GraphQL::FancyLoader
  from MediaReactionVote

  sort :created_at
  sort :following,
    transform: ->(ast, context) {
      follows = Follow.arel_table
      votes = MediaReactionVote.arel_table

      condition = follows[:followed_id].eq(votes[:user_id]).and(
        follows[:follower_id].eq(context[:user]&.id)
      )

      ast.join(follows, Arel::Nodes::OuterJoin).on(condition)
    },
    on: -> { Follow.arel_table[:id] }
end
