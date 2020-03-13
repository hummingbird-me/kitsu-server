class Mutations::Anime::Delete < Mutations::BaseMutation
  argument :id, ID,
    required: true,
    description: 'ID of the Anime to delete'

  field :result, Types::DeleteResult, null: false

  def resolve(id:)
    anime = Anime.find(id)
    authorize anime, :destroy?
    anime.destroy!
    { result: { id: id, type_name: 'Anime' } }
  end
end
