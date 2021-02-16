class Mutations::Episode::Create < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::Episode::Create,
    required: true,
    description: 'Create an Episode',
    as: :episode

  field :episode, Types::Episode, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_episode(value)
    ::Episode.new(value.to_model)
  end

  def authorized?(episode:)
    super(episode, :create?)
  end

  def resolve(episode:)
    episode.save!

    { episode: episode }
  end
end
