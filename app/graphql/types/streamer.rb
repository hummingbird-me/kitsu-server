class Types::Streamer < Types::BaseObject
  description 'The company who is streaming.'

  field :id, ID, null: false

  field :site_name, String,
    null: false,
    description: 'The name of the site that is streaming this media.'

  field :streaming_links, Types::StreamingLink.connection_type,
    null: false,
    description: 'Additional media this site is streaming.'

  field :videos, Types::Videos.connection_type,
    null: false,
    description: 'Videos of the media being streamed.'
end
