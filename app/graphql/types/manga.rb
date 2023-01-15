class Types::Manga < Types::BaseObject
  implements Types::Interface::Media
  implements Types::Interface::WithTimestamps

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

  field :serialization, String,
    null: true,
    description: "The serialization of this manga."

  field :chapters, Types::Chapter.connection_type, null: true do
    description 'The chapters in the manga.'
    argument :sort, Loaders::CharacterVoicesLoader.sort_argument, required: false
  end

  def chapters(sort: [{ on: :number, direction: :asc }])
    Loaders::ChaptersLoader.connection_for({
      find_by: :manga_id,
      sort: sort
    }, object.id)
  end
end
