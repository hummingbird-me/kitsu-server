class Loaders::ReportsLoader < Loaders::FancyLoader
  from Report

  sort :created_at
  sort :updated_at
end
