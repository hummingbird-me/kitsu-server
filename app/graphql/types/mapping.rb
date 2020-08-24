class Types::Mapping < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'Media Mappings from External Sites (MAL, Anilist, etc..) to Kitsu.'

  field :id, ID, null: false

  field :external_site, Types::Enum::MappingExternalSite,
    null: false,
    description: 'The name of the site which kitsu media is being linked from.'

  field :external_id, ID,
    null: false,
    description: 'The ID of the media from the external site.'

  field :item, Types::Union::MappingItem,
    null: false,
    description: 'The kitsu object that is mapped.'
end
