class Types::Video < Types::BaseObject
  description ''

  field :id, ID, null: false

  field :url, String,
    null: false,
    description: 'The url of the video.'

  # Might want to turn into enum
  field :available_regions, [String],
    null: false,
    description: 'Which regions this video is available in.'

  field :sub_language, String,
    null: false,
    description: 'The language this is subbed in',
    method: :sub_lang

  field :dub_language, String,
    null: false,
    description: 'The language this is dubbed in.',
    method: :dub_lang

  field :episode, Types::Episode,
    null: false,
    description: 'The episode of this video'

  field :streamer, Types::Streamer,
    null: false,
    description: 'The streamer of this video'
end
