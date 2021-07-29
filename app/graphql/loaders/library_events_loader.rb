class Loaders::LibraryEventsLoader < Loaders::FancyLoader
  from LibraryEvent

  sort :created_at
  sort :updated_at
end
