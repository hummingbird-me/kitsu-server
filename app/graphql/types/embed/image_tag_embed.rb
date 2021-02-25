class Types::Embed::ImageTagEmbed < Types::BaseObject
  implements Types::Interface::BaseTagEmbed

  description 'Image Properties'

  field :width, String,
    null: false,
    description: 'The number of pixels wide.'

  field :height, String,
    null: false,
    description: 'The number of pixels high.'

  field :alt, String,
    null: false,
    description: 'A description of what is in the image (not a caption).'
end
