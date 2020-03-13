class Mutations::Anime::Create < Mutations::BaseMutation
  argument :input, Inputs::AnimeCreateInput,
    required: true,
    description: 'New Anime to create'

  field :anime, Types::Anime, null: true

  def resolve(input:)
    authorize Anime, :create?
    anime = Anime.create!(input.to_model)
    { anime: anime }
  end
end
