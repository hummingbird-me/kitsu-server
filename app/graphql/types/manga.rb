class Types::Manga < Types::BaseObject
  implements Types::Media

  field :chapter_count, Integer,
    null: true,
    description: 'The number of chapters in this series'

  field :volume_count, Integer,
    null: true,
    description: 'The number of volumes in this series'

  field :chapters, Types::Chapter.connection_type, null: false do
    description 'Chapters for this manga'
    argument :number, [Integer], required: false
  end

  def chapters(number: nil)
    if number
      object.chapters.where(number: number)
    else
      AssociationLoader.for(Manga, :chapters).load(object).then(&:to_a)
    end
  end

  # TODO: add volume association so that someone can supply a volume number
  # to get volume information and also all chapters related to it.
end
