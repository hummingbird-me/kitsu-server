class Mutations::Anime::Update < Mutations::BaseMutation
  argument :id, ID,
    required: true,
    description: 'ID of the Anime to update'
  argument :input, Inputs::AnimeUpdateInput,
    required: true,
    description: 'Anime attributes to update'

  field :anime, Types::Anime, null: true

  def resolve(id:, input:)
    anime = Anime.find(id)
    anime.update!(input.to_model)
    { anime: anime }
  end
end
