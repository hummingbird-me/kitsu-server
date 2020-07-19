class Types::Manga < Types::BaseObject
  implements Types::Media

  field :subtype, Types::Enum::MangaSubtype,
    null: false,
    description: 'A secondary type for categorizing Manga.'
end
