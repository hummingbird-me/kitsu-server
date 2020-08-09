class Types::Video < Types::BaseObject
  implements Types::Interface::Streamable
  description 'The media video.'

  field :id, ID, null: false

  field :url, String,
    null: false,
    description: 'The url of the video.'

  field :available_regions, [String],
    null: false,
    description: 'Which regions this video is available in.',
    deprecation_reason: 'Please use regions.',
    method: :regions

  field :sub_language, String,
    null: false,
    description: 'The language this is subbed in',
    deprecation_reason: 'Please use subs',
    method: :sub_lang

  field :dub_language, String,
    null: false,
    description: 'The language this is dubbed in.',
    deprecation_reason: 'Please use dubs',
    method: :dub_lang

  field :episode, Types::Episode,
    null: false,
    description: 'The episode of this video'
end
