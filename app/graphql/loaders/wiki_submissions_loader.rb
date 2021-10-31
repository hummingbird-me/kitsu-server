class Loaders::WikiSubmissionsLoader < GraphQL::FancyLoader
  from WikiSubmission

  sort :created_at
  sort :updated_at
end
