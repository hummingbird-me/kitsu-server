# frozen_string_literal: true

class Loaders::VolumesLoader < GraphQL::FancyLoader
  from Volume

  sort :created_at
  sort :updated_at
  sort :number
end
