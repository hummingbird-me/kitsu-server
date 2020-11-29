module Types::Interface::BaseEmbed
  include Types::Interface::Base
  description 'Required and Optional fields for an Embed based off the Open Graph protocol'

  orphan_types Types::Embed::WebsiteEmbed

  field :title, String,
    null: false,
    description: 'The title of your object as it should appear within the graph.'

  field :kind, String,
    null: false,
    description: <<~DESCRIPTION.squish
      The type of your object,
      e.g., "video.movie".
      Depending on the type you specify, other properties may also be required.
    DESCRIPTION

  field :url, String,
    null: false,
    description: 'The canonical URL of your object that will be used as its permanent ID in the graph'

  field :image, Types::Embed::ImageTagEmbed,
    null: false,
    description: 'An image URL which should represent your object within the graph.'

  field :audio, Types::Embed::AudioTagEmbed,
    null: true,
    description: 'A URL to an audio file to accompany this object.'

  field :description, String,
    null: true,
    description: 'A one to two sentence description of your object.'

  field :determiner, String,
    null: true,
    description: <<~DESCRIPTION.squish
      The word that appears before this object's title in a sentence.
      An enum of (a, an, the, "", auto). If auto is chosen,
      the consumer of your data should chose between "a" or "an". Default is "" (blank).
    DESCRIPTION

  field :locale, String,
    null: true,
    description: <<~DESCRIPTION.squish
      The locale these tags are marked up in.
      Of the format language_territory.
      Default is en_us.
    DESCRIPTION

  field :locale_alternative, [String],
    null: true,
    description: 'An array of other locales this page is available in.'

  field :site, String,
    null: true,
    description: ''

  field :site_name, String,
    null: true,
    description: <<~DESCRIPTION.squish
      If your object is part of a larger web site,
      the name which should be displayed for the overall site.
    DESCRIPTION

  field :video, Types::Embed::VideoTagEmbed,
    null: true,
    description: 'A URL to a video file that complements this object.'
end
