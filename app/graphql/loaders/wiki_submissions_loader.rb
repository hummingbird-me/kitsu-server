class Loaders::WikiSubmissionsLoader < Loaders::FancyLoader
  from WikiSubmission

  sort :created_at
  sort :updated_at
end
