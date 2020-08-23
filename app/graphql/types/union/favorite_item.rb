class Types::Union::FavoriteItem < Types::Union::Base
  description 'Objects which are Favoritable'

  possible_types Types::Anime, Types::Manga, Types::Character, Types::Person
end
