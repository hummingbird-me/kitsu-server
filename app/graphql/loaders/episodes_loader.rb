class Loaders::EpisodesLoader < Loaders::FancyLoader
  from Episode

  sort :created_at
  sort :updated_at
  sort :number
end
