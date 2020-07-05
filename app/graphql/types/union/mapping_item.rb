class Types::Union::MappingItem < Types::Union::Base
  description 'Objects which are Mappable'

  possible_types Types::Anime, Types::Manga, Types::Character
end
