class GenreResource < BaseResource
  caching

  attributes :name, :slug, :description

  paginator :unlimited

  def description
    _model.description['en']
  end
end
