class Mutations::Manga::Update < Mutations::Base
  argument :input,
    Types::Input::Manga::Update,
    required: true,
    description: 'Update Manga',
    as: :manga

  field :manga, Types::Manga, null: true

  def load_manga(value)
    manga = ::Manga.find(value.id)
    manga.assign_attributes(value.to_h)
    manga
  end

  def authorized?(manga:)
    super(manga, :update?)
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
