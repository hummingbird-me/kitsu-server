class Mutations::Episode::Delete < Mutations::Base
  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Delete an Episode',
    as: :episode

  field :episode, Types::GenericDelete, null: true

  def load_episode(value)
    ::Episode.find(value.id)
  end

  def authorized?(episode:)
    super(episode, :destroy?)
  end

  def resolve(episode:)
    episode.destroy

    if episode.errors.any?
      Errors::RailsModel.graphql_error(episode)
    else
      {
        episode: { id: episode.id }
      }
    end
  end
end
