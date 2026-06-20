class Loaders::EpisodesLoader < GraphQL::FancyLoader
  from Post

  sort :created_at
  sort :updated_at
  sort :id
end
