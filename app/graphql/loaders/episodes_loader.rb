class Loaders::EpisodesLoader < GraphQL::FancyLoader
  from Episode

  sort :created_at
  sort :updated_at
  sort :number
end
