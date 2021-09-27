class Loaders::CharacterVoicesLoader < Loaders::FancyLoader
  from CharacterVoice

  sort :created_at
  sort :updated_at
end
