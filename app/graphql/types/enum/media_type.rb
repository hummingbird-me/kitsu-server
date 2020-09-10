class Types::Enum::MediaType < Types::Enum::Base
  description 'これはアニメやマンガです'
  graphql_name 'MediaTypeEnum'

  value 'ANIME', value: 'Anime'
  value 'MANGA', value: 'Manga'
end
