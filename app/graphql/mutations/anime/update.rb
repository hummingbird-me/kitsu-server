class Mutations::Anime::Update < Mutations::Base
  argument :input,
    Types::Input::Anime::Update,
    required: true,
    description: 'Update an Anime.',
    as: :anime

  field :anime, Types::Anime, null: true

  def load_anime(value)
    anime = ::Anime.find(value.id)
    anime.assign_attributes(value.to_model)
    anime
  end

  def authorized?(anime:)
    super(anime, :update?)
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
