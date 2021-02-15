class Mutations::Manga::Delete < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Delete Manga',
    as: :manga

  field :manga, Types::GenericDelete, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_manga(value)
    ::Manga.find(value.id)
  end

  def authorized?(manga:)
    super(manga, :destroy?)
  end

  def resolve(manga:)
    manga.destroy!

    { manga: { id: manga.id } }
  end
end
