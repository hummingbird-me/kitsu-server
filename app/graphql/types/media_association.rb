class Types::MediaAssociation < Types::BaseObject
  description 'Media related to the Library Entry List.'

  field :anime, Types::AnimeList, null: false
  field :manga, Types::MangaList, null: false

  def anime
    object
  end

  def manga
    object
  end
end
