class Loaders::LibraryEventsLoader < GraphQL::FancyLoader
  from LibraryEvent

  sort :created_at
  sort :updated_at
end
