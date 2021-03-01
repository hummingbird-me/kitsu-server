class Types::Enum::SortDirection < GraphQL::Schema::Enum
  value :ASCENDING, value: :asc
  value :DESCENDING, value: :desc
end
