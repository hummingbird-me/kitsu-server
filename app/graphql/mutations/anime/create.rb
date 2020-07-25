class Mutations::Anime::Create < Mutations::Base
  argument :input,
    Types::Input::Anime::Create,
    required: true,
    description: 'Create an Anime.',
    as: :anime

  field :anime, Types::Anime, null: true

  def load_anime(value)
    ::Anime.new(value.to_h)
  end

  def authorized?(anime:)
    super(anime, :create?)
  end

  def resolve(anime:)
    anime.save

    if anime.errors.any?
      Errors::RailsModel.graphql_error(anime)
    else
      {
        anime: anime
      }
    end
  end
end
