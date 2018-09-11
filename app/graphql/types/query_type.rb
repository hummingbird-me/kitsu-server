class Types::QueryType < Types::BaseObject
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :anime, Types::Anime.connection_type, null: false do
    description 'Anime in the Kitsu database'
    argument :slug, [String], required: false
    argument :id, [String], required: false
  end

  def anime(slug: nil, id: nil)
    if slug
      Anime.by_slug(slug)
    elsif id
      Anime.find(id)
    end
  end
end
