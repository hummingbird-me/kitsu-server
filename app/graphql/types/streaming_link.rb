class Types::StreamingLink < Types::BaseObject
  description ''

  field :id, ID, null: false

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media being streamed'

  field :dubs, [String],
    null: false,
    description: 'Spoken language is replaced by language of choice.'

  field :subs, [String],
    null: false,
    description: 'Languages this is translated to. Usually placed at bottom of media.'

  field :url, String,
    null: false,
    description: 'Fully qualified URL for the streaming link.'

  field :streamer, Types::Streamer,
    null: false,
    description: 'The site that is streaming this media.'
end
