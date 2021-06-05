class Loaders::ReviewsLoader < Loaders::FancyLoader
  from Reviews

  sort :created_at
  sort :updated_at
end
