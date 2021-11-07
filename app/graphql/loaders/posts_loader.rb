class Loaders::PostsLoader < GraphQL::FancyLoader
  from Post
  sort :created_at
end
