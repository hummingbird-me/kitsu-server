class Loaders::MediaCharactersLoader < Loaders::FancyLoader
  from MediaCharacter

  sort :created_at
  sort :updated_at
end
