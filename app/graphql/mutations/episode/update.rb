class Mutations::Episode::Update < Mutations::Base
  argument :input,
    Types::Input::Episode::Update,
    required: true,
    description: 'Update an Episode',
    as: :episode

  field :episode, Types::Episode, null: true

  def load_episode(value)
    episode = ::Episode.find(value.id)
    episode.assign_attributes(value.to_model)
    episode
  end

  def authorized?(episode:)
    super(episode, :update?)
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
