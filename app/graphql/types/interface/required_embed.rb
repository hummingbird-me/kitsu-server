module Types::Interface::RequiredEmbed
  include Types::Interface::Base
  description 'Required fields for an Embed based off the Open Graph protocol'

  field :title, String,
  null: true,
  description: ''

  field :kind, String,
    null: false,
    description: ''

  field :description, String,
    null: true,
    description: ''

  field :site, String,
    null: true,
    description: ''

  field :url, String,
    null: true,
    description: ''

  # field :image, Types::EmbedImage,
  #   null: true,
  #   description: ''
end