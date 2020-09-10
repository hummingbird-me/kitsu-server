class Types::Enum::MediaType < Types::Enum::Base
  description 'これはアニメやマンガです'
  graphql_name 'MediaType'

  value 'ANIME', value: 'Anime'
  value 'MANGA', value: 'Manga'
end
