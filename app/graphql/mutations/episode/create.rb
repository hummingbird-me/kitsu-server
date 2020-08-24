class Mutations::Episode::Create < Mutations::Base
  argument :input,
    Types::Input::Episode::Create,
    required: true,
    description: 'Create an Episode',
    as: :episode

  field :episode, Types::Episode, null: true

  def load_episode(value)
    ::Episode.new(value.to_model)
  end

  def authorized?(episode:)
    super(episode, :create?)
  end

  def resolve(episode:)
    episode.save

    if episode.errors.any?
      Errors::RailsModel.graphql_error(episode)
    else
      {
        episode: episode
      }
    end
  end
end
