class Loaders::MediaCharactersLoader < GraphQL::FancyLoader
  from MediaCharacter

  sort :created_at
  sort :updated_at
  sort :role, on: -> { Arel::Nodes::Subtraction.new(0, MediaCharacter.arel_table[:role]) }
end
