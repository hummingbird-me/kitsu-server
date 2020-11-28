class Types::Embed::VideoTagEmbed < Types::BaseObject
  implements Types::Interface::BaseEmbed

  description 'Video Properties'

  field :width, String,
    null: false,
    description: 'The number of pixels wide.'

  field :height, String,
    null: false,
    description: 'The number of pixels high.'

  field :alt, String,
    null: false,
    description: 'A description of what is in the video (not a caption).'
end
