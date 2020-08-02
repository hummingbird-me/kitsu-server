class Mutations::Manga::Delete < Mutations::Base
  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Delete Manga',
    as: :manga

  field :manga, Types::GenericDelete, null: true

  def load_manga(value)
    ::Manga.find(value.id)
  end

  def authorized?(manga:)
    super(manga, :destroy?)
  end

  def resolve(manga:)
    manga.destroy

    if manga.errors.any?
      Errors::RailsModel.graphql_error(manga)
    else
      {
        manga: { id: manga.id }
      }
    end
  end
end
