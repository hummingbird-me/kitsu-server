class Mutations::Anime::Create < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::Anime::Create,
    required: true,
    description: 'Create an Anime.',
    as: :anime

  field :anime, Types::Anime, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_anime(value)
    ::Anime.new(value.to_model)
  end

  def authorized?(anime:)
    super(anime, :create?)
  end

  def resolve(anime:)
    anime.save!

    { anime: anime }
  end
end
