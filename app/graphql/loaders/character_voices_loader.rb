class Loaders::CharacterVoicesLoader < GraphQL::FancyLoader
  from CharacterVoice

  sort :created_at
  sort :updated_at
end
