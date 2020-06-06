class Types::MangaList < Types::BaseObject
  include LibraryEntryList

  def media_type
    'Manga'
  end
end
