class GenreResource < BaseResource
  caching

  attributes :name, :slug, :description

  paginator :unlimited
end
