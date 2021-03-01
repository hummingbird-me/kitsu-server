class Loaders::PostsLoader < Loaders::FancyLoader
  from Post
  sort :created_at
end
