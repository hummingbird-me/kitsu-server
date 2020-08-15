class Types::Video < Types::BaseObject
  implements Types::Interface::Streamable
  description 'The media video.'

  field :id, ID, null: false

  field :url, String,
    null: false,
    description: 'The url of the video.'

  field :episode, Types::Episode,
    null: false,
    description: 'The episode of this video'
end
