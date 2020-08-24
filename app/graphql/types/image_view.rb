class Types::ImageView < Types::BaseObject
  implements Types::Interface::WithTimestamps

  field :name, String,
    null: false,
    description: 'The name of this view of the image'

  field :url, String,
    null: false,
    description: 'The URL of this view of the image'

  field :width, Integer,
    null: true,
    description: 'The width of the image'

  field :height, Integer,
    null: true,
    description: 'The height of the image'
end
