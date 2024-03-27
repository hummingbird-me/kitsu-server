# frozen_string_literal: true

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

  field :volumes, Types::Volume.connection_type, null: true do
    description 'The volumes in the manga.'
    argument :sort, Loaders::VolumesLoader.sort_argument, required: false
  end

  def volumes(sort: [{ on: :number, direction: :asc }])
    Loaders::VolumesLoader.connection_for({
      find_by: :manga_id,
      sort:
    }, object.id)
  end

  field :chapters, Types::Chapter.connection_type, null: true do
    description 'The chapters in the manga.'
    argument :sort, Loaders::ChaptersLoader.sort_argument, required: false
  end

  def chapters(sort: [{ on: :number, direction: :asc }])
    Loaders::ChaptersLoader.connection_for({
      find_by: :manga_id,
      sort:
    }, object.id)
  end

  field :chapter, Types::Chapter, null: true do
    description 'Get a specific chapter of the manga.'
    argument :number, Integer, required: true
  end

  def chapter(number:)
    Loaders::RecordLoader.for(
      Chapter,
      where: { manga_id: object.id },
      token: context[:token],
      column: :number
    ).load(number)
  end
end
