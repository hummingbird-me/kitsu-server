class Types::Manga < Types::BaseObject
  implements Types::Interface::Media

  field :subtype, Types::Enum::MangaSubtype,
    null: false,
    description: 'A secondary type for categorizing Manga.'

  field :chapter_count, Integer,
    null: true,
    description: 'The number of chapters in this manga.'

  field :chapter_count_guess, Integer,
    null: true,
    description: 'The estimated number of chapters in this manga.'

  field :volume_count, Integer,
    null: true,
    description: 'The number of volumes in this manga.'
end
