class Types::MediaType < Types::BaseEnum
  graphql_name 'MediaType'

  value 'ANIME', value: 'Anime'
  value 'MANGA', value: 'Manga'
end
