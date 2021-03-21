class Loaders::FollowsLoader < Loaders::FancyLoader
  from Follow
  # Sort by whether you follow the followed person
  sort :following_followed,
    transform: ->(ast) {
      their_follows = Follow.arel_table
      your_follows = Follow.arel_table.alias('yours')

      condition = your_follows[:followed_id].eq(their_follows[:followed_id]).and(
        your_follows[:follower_id].eq(User.current&.id)
      )

      ast.join(your_follows, Arel::Nodes::OuterJoin).on(condition)
    },
    on: -> { Follow.arel_table.alias('yours')[:id] }
  # Sort by whether you follow the following person
  sort :following_follower,
    transform: ->(ast) {
      their_follows = Follow.arel_table
      your_follows = Follow.arel_table.alias('yours')

      condition = your_follows[:followed_id].eq(their_follows[:follower_id]).and(
        your_follows[:follower_id].eq(User.current&.id)
      )

      ast.join(your_follows, Arel::Nodes::OuterJoin).on(condition)
    },
    on: -> { Follow.arel_table.alias('yours')[:id] }
  sort :created_at
end
