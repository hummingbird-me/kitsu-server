class Mutations::Anime::Delete < Mutations::Base
  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Delete an Anime.',
    as: :anime

  field :anime, Types::GenericDelete, null: true

  def load_anime(value)
    ::Anime.find(value.id)
  end

  def authorized?(anime:)
    super(anime, :destroy?)
  end

  def resolve(anime:)
    anime.destroy

    if anime.errors.any?
      Errors::RailsModel.graphql_error(anime)
    else
      {
        anime: { id: anime.id }
      }
    end
  end
end
