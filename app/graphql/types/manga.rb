class Types::Manga < Types::BaseObject
  implements Types::Media

  field :chapter_count, Integer,
    null: true,
    description: 'The number of chapters in this series'

  field :volume_count, Integer,
    null: true,
    description: 'The number of volumes in this series',
    deprecation_reason: 'Changed to rather use a Volume model'

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

  field :volumes, Types::Volume.connection_type, null: false do
    description 'Volumes for this manga'
    argument :number, [Integer], required: false
  end

  def volumes(number: nil)
    if number
      object.volumes.where(number: number)
    else
      AssociationLoader.for(Manga, :volumes).load(object).then(&:to_a)
    end
  end
end
