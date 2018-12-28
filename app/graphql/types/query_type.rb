class Types::QueryType < Types::BaseObject
  field :anime, Types::Anime.connection_type, null: false do
    description 'Anime in the Kitsu database'
    argument :slug, [String], required: false
    argument :id, [String], required: false
  end

  def anime(slug: nil, id: nil)
    if slug
      ::Anime.by_slug(slug)
    elsif id
      ::Anime.find(id)
    else
      ::Anime.all
    end
  end

  field :find_profile, Types::Profile, null: true do
    description 'Find a single user in the Kitsu database by slug or ID'
    argument :slug, String, required: false
    argument :id, String, required: false
  end

  def find_profile(slug: nil, id: nil)
    if slug
      ::User.find_by_slug(slug)
    elsif id
      ::User.find_by_id(id)
    end
  end
end
