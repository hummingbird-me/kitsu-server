module Types::Interface::Episodic
  include Types::Interface::Base
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
    argument :number, [Integer], required: false, deprecation_reason: 'This should only grab all episodes. Separate field will be provided for specific episodes'
    argument :sort, Loaders::EpisodesLoader.sort_argument, required: false
  end

  def episodes(sort: [{ on: :number, direction: :asc }], number: nil)
    where = { media_type: type, number: number }.compact

    Loaders::EpisodesLoader.connection_for({
      find_by: :media_id,
      sort: sort,
      where: where
    }, object.id)
  end
end
