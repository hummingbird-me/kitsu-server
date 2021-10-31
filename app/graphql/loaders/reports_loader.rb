class Loaders::ReportsLoader < GraphQL::FancyLoader
  from Report

  sort :created_at
  sort :updated_at
end
