class Loaders::MediaReactionsLoader < GraphQL::FancyLoader
  from MediaReaction

  sort :created_at
  sort :updated_at
  sort :up_votes_count
end
