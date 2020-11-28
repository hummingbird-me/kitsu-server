module Types::Interface::BaseMediaEmbed
  include Types::Interface::Base

  description 'Similar fields between Image, Audio, Video Tags.'

  field :url, String,
    null: false,
    description: 'A url.'

  field :secure_url, String,
    null: true,
    description: 'An alternate url to use if the webpage requires HTTPS.'

  field :kind, String,
    null: true,
    description: 'A MIME type'
end
