class Mutations::Manga::Create < Mutations::Base
  argument :input,
    Types::Input::Manga::Create,
    required: true,
    description: 'Create Manga',
    as: :manga

  field :manga, Types::Manga, null: true

  def load_manga(value)
    ::Manga.new(value.to_h)
  end

  def authorized?(manga:)
    super(manga, :create?)
  end

  def resolve(manga:)
    manga.save

    if manga.errors.any?
      Errors::RailsModel.graphql_error(manga)
    else
      {
        manga: manga
      }
    end
  end
end
