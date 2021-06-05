class Loaders::ReviewsLoader < Loaders::FancyLoader
  from Review

  sort :created_at
  sort :updated_at
end
