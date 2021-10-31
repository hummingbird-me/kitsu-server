class Loaders::ReviewsLoader < GraphQL::FancyLoader
  from Review

  sort :created_at
  sort :updated_at
end
