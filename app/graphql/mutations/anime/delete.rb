class Mutations::Anime::Delete < Mutations::BaseMutation
  argument :id, ID,
    required: true,
    description: 'ID of the Anime to delete'

  field :result, Types::AnimeDeleteResult, null: false

  def resolve(id:)
    anime = Anime.find(id)
    authorize anime, :destroy?
    anime.destroy!
    { result: { id: id, deleted: true } }
  end
end
