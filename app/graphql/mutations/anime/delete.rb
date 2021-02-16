class Mutations::Anime::Delete < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Delete an Anime.',
    as: :anime

  field :anime, Types::GenericDelete, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_anime(value)
    ::Anime.find(value.id)
  end

  def authorized?(anime:)
    super(anime, :destroy?)
  end

  def resolve(anime:)
    anime.destroy!

    { anime: { id: anime.id } }
  end
end
