class Mutations::Episode::Delete < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Delete an Episode',
    as: :episode

  field :episode, Types::GenericDelete, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_episode(value)
    ::Episode.find(value.id)
  end

  def authorized?(episode:)
    super(episode, :destroy?)
  end

  def resolve(episode:)
    episode.destroy!

    { episode: { id: episode.id } }
  end
end
