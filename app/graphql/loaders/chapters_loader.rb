class Loaders::ChaptersLoader < Loaders::FancyLoader
  from Chapter

  sort :created_at
  sort :updated_at
  sort :number
end
