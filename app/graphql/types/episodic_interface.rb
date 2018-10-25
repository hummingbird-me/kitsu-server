module Types::EpisodicInterface
  include Types::BaseInterface
  description 'An episodic media in the Kitsu database'

  field :episode_count, Integer,
    null: true,
    description: 'The number of episodes in this series'

  field :episode_length, Integer,
    null: true,
    description: 'The general length (in seconds) of each episode'

  field :total_length, Integer,
    null: true,
    description: 'The total length (in seconds) of the entire series'

  field :episodes, Types::Episode.connection_type, null: false do
    description 'Episodes for this media'
    argument :number, [Integer], required: false
  end

  def episodes(number: nil)
    episodes = object.episodes
    episodes = episodes.where(number: number) if number
    episodes.order(number: :asc)
  end
end
