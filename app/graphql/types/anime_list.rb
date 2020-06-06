class Types::AnimeList < Types::BaseObject
  include LibraryEntryList

  def media_type
    'Anime'
  end
end
